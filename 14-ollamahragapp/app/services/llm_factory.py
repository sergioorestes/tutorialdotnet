# pylint: disable=C0114,C0411,C0301,C0413,,E1101

from typing import Any, Dict, List, Type, Optional

import ollama
from pydantic import BaseModel, ValidationError
import logging
import json
import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent))

from config.settings import get_settings

class LLMFactory:
    """Factory class to initialize different LLM providers dynamically (only supports Mistral via Ollama)."""

    @classmethod
    def __init__(cls):
        cls.settings = get_settings()
        cls.default_model = cls.settings.mistral.default_model
        cls.temperature = cls.settings.mistral.temperature
        cls.max_tokens = cls.settings.mistral.max_tokens

        if not cls.settings:
            raise ValueError("❌ Mistral configuration is missing in settings.")

        cls.client = cls._initialize_client()

    @classmethod
    def _initialize_client(cls) -> Any:
        """Initialize the client for Mistral via Ollama."""
        return {"model": cls.default_model}

    @classmethod
    def create_completion(
            cls, response_model: Optional[Type[BaseModel]], messages: List[Dict[str, str]], **kwargs
    ) -> Any:
        """Generate a completion response using Mistral via Ollama.

        Args:
            response_model: A Pydantic model to parse the response (optional).
            messages: List of chat messages.

        Returns:
            Parsed response if response_model is provided, otherwise raw text.
        """

        response = ollama.chat(
            model= cls.client["model"],
            messages=messages,
            options={
                "temperature": kwargs.get("temperature", cls.temperature),
                "num_ctx": kwargs.get("max_tokens", cls.max_tokens),
            },
        )

        # Extraire la réponse texte brute
        if "message" in response:
            raw_text = response["message"]["content"]
        else:
            logging.error("❌ Error from Ollama %s: ", response)
            return None

        logging.info("📝 Ollama Response: %s: ", raw_text)

        # 🛠️ Tentative de parsing en JSON si un response_model est fourni
        if response_model:
            try:
                json_response = json.loads(raw_text)  # Convertit la réponse en JSON
                parsed_response = response_model.model_validate(json_response)  # Vérifie la structure
                return parsed_response
            except (json.JSONDecodeError, ValidationError) as e:
                logging.error("❌ Error parsing response: %s", e)
                return None

        return raw_text  # Retourne du texte brut si pas de `response_model`

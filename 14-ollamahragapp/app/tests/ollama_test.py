# pylint: disable=C0114,C0115,C0116,C0301,W0611
import unittest

import ollama

class OllamaTest(unittest.TestCase):

    def test_ollama_embeddings(self):
        response = ollama.embeddings(
            model="bert_tiny_embeddings_english_portuguese-unsloth",
            prompt="Hello world",
        )

        print(response['embedding'])

if __name__ == "__main__":
    unittest.main()

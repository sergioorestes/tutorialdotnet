# pylint: disable=C0114,C0116,C0411,C0103,C0301

from datetime import datetime
from database.vector_store import VectorStore
from services.synthesizer import Synthesizer
from timescale_vector import client

# Initialize VectorStore
vector_store = VectorStore()

relevant_question = "Qual é o CNPJ da Drogaria Campeã da Lapa?"

# --------------------------------------------------------------
# Shipping question
# --------------------------------------------------------------
def shipping_question():
    results = vector_store.search(relevant_question, limit=3)

    response = Synthesizer.generate_response(question=relevant_question, context=results)

    print(f"\n{response.answer}")
    print("\nThought process:")
    for thought in response.thought_process:
        print(f"- {thought}")
    print(f"\nContext: {response.enough_context}")

# --------------------------------------------------------------
# Irrelevant question
# --------------------------------------------------------------
def irrelevant_question():
    question = "Qual o clima em Tóquio?"

    results = vector_store.search(question, limit=3)

    response = Synthesizer.generate_response(question=question, context=results)

    print(f"\n{response.answer}")
    print("\nThought process:")
    for thought in response.thought_process:
        print(f"- {thought}")
    print(f"\nContext: {response.enough_context}")

# --------------------------------------------------------------
# Metadata filtering
# --------------------------------------------------------------
def metadata_filtering():
    metadata_filter = {"category": "Shipping"}

    results = vector_store.search(relevant_question, limit=3, metadata_filter=metadata_filter)

    response = Synthesizer.generate_response(question=relevant_question, context=results)

    print(f"\n{response.answer}")
    print("\nThought process:")
    for thought in response.thought_process:
        print(f"- {thought}")
    print(f"\nContext: {response.enough_context}")

# --------------------------------------------------------------
# Advanced filtering using Predicates
# --------------------------------------------------------------
def advanced_filtering_predicates():
    predicates = client.Predicates("category", "==", "Shipping")
    results = vector_store.search(relevant_question, limit=3, predicates=predicates)
    print(results)

    predicates = client.Predicates("category", "==", "Shipping") | client.Predicates(
        "category", "==", "Services"
    )
    results = vector_store.search(relevant_question, limit=3, predicates=predicates)

    print(results)
    predicates = client.Predicates("category", "==", "Shipping") & client.Predicates(
        "created_at", ">", "2024-09-01"
    )
    results = vector_store.search(relevant_question, limit=3, predicates=predicates)
    print(results)

# --------------------------------------------------------------
# Time-based filtering
# --------------------------------------------------------------
def timebased_filtering():
    # September — Returning results
    time_range = (datetime(2024, 9, 1), datetime(2024, 9, 30))
    results = vector_store.search(relevant_question, limit=3, time_range=time_range)
    print(results)
    # August — Not returning any results
    time_range = (datetime(2024, 8, 1), datetime(2024, 8, 30))
    results = vector_store.search(relevant_question, limit=3, time_range=time_range)
    print(results)

if __name__ == "__main__":
    shipping_question()
    # irrelevant_question()
    # metadata_filtering()
    # advanced_filtering_predicates()
    # timebased_filtering()

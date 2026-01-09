# pylint: disable=C0114,C0411,C0301

from datetime import datetime

import pandas as pd
from database.vector_store import VectorStore
from timescale_vector.client import uuid_from_time
import os
from pathlib import Path

os.chdir(Path(__file__).parent.parent.resolve())

# Initialize VectorStore
vec = VectorStore()

# Read the CSV file
df = pd.read_csv("datasets/SELLOUT_SELLIN_ESTOQUE_HISTORICO_26246169000110_20250606_032528_v02.alpaca", sep=",")

# Prepare data for insertion
def prepare_record(row):
    """Prepare a record for insertion into the vector store.

    This function creates a record with a UUID version 1 as the ID, which captures
    the current time or a specified time.

    Note:
        - By default, this function uses the current time for the UUID.
        - To use a specific time:
          1. Import the datetime module.
          2. Create a datetime object for your desired time.
          3. Use uuid_from_time(your_datetime) instead of uuid_from_time(datetime.now()).

        Example:
            from datetime import datetime
            specific_time = datetime(2023, 1, 1, 12, 0, 0)
            id = str(uuid_from_time(specific_time))

        This is useful when your content already has an associated datetime.
    """
    content = f"Question: {row['INSTRUCTION']}\nAnswer: {row['RESPONSE']}"
    embedding = vec.get_embedding(content)

    return pd.Series(
        {
            "id": str(uuid_from_time(datetime.now())),  # Generates time-based UUID
            "metadata": {
                "input": row["INPUT"],
                "created_at": datetime.now().isoformat(),
            },
            "content": content,
            "embedding": embedding,
        }
    )

if __name__ == "__main__":
    records_df = df.apply(prepare_record, axis=1)

    # Create tables and insert data
    vec.create_tables()
    vec.create_index()  # HNSWIndex
    vec.upsert(records_df)

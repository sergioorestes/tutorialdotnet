# pylint: disable=C0114,C0115,C0116,C0301,W0611
import unittest

import psycopg2
from timescale_vector import client

class TimescaleTest(unittest.TestCase):

    DATABASE_URL = "postgresql://postgres:postgres@localhost:5432/postgres"

    def test_ollama_embeddings(self):
        conn = psycopg2.connect(self.DATABASE_URL)

        # vec_client = client.Sync(self.DATABASE_URL, "documents", 768)
        # vec_client.create_tables()

        print(conn.info)

if __name__ == "__main__":
    unittest.main()

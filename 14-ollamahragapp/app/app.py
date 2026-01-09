# pylint: disable=C0114,C0116,C0103,C0301

import os
from pathlib import Path
import csv
from datetime import datetime
import pandas as pd
from timescale_vector.client import uuid_from_time
from database.vector_store import VectorStore

os.chdir(Path(__file__).parent.parent.resolve())

input_file_path = "datasets/SELLOUT_SELLIN_ESTOQUE_HISTORICO_26246169000110_20250606_032528_v02.csv"

vector_store = VectorStore()

def prepare_record(row):
    content = f"Question: {row['INSTRUCTION']}\nAnswer: {row['RESPONSE']}"
    embedding = vector_store.get_embedding(content)

    return pd.Series(
        {
            "id": str(uuid_from_time(datetime.now())),  # Generates time-based UUID
            "metadata": {
                "createdAt": datetime.now().isoformat(),
            },
            "content": content,
            "embedding": embedding,
        }
    )


def insert_vectors():

    with open(
        f"{input_file_path}",
        mode="r",
        encoding="utf-8",
    ) as infile:
        reader = csv.DictReader(infile, delimiter=",", lineterminator="\n")

        formatted_data = []

        for row in reader:
            company_columns = f'{row["CODIGO_GRUPO_EMPRESARIAL_GE"]} {row["NOME_GE"]} {row["CODIGO_EMPRESA_GE"]} {row["NOME_EMPRESA_GE"]} {row["NOME_FANTASIA_EMPRESA_GE"]} {row["CNPJ_EMPRESA_GE"]}'
            product_columns = f'{row["CODIGO_INTERNO_SKU"]} {row["NOME_SKU"]} {row["EAN_TEXTO_SKU"]} {row["EAN_NUMERICO_SKU"]} {row["EAN_PRINCIPAL_SKU"]} {row["UNIDADE_MEDIDA_SKU"]} {row["CODIGO_NCM_SKU"]} {row["CODIGO_CEST_SKU"]} {row["DATA_CADASTRO_SKU"]} {row["SITUACAO_SKU"]} {row["CODIGO_FABRICANTE_SKU"]} {row["NOME_FABRICANTE_SKU"]} {row["CODIGO_MARCA_SKU"]} {row["NOME_MARCA_SKU"]}'
            channel_columns = f'{row["CODIGO_CANAL_VENDA"]} {row["NOME_CANAL_VENDA"]} {row["CODIGO_ORIGEM_VENDA"]} {row["NOME_ORIGEM_VENDA"]} {row["CODIGO_CFOP_VENDA"]} {row["ORDERID_CUPOM_VENDA"]} {row["SKU_DATA_VENDA"]} {row["SKU_QUANTIDADE_VENDA"]} {row["SKU_TOTAL_BRUTO_VENDA"]} {row["SKU_TOTAL_DESCONTO_VENDA"]} {row["SKU_TOTAL_LIQUIDO_VENDA"]} {row["SKU_PRECO_MEDIO_VENDA"]} {row["SKU_TOTAL_CMV_VENDA"]} {row["SKU_TOTAL_COMISSAO_VENDA"]} {row["SKU_TOTAL_BONIFICACAO_VENDA"]} {row["SKU_TOTAL_IMPOSTOS_VENDA"]} {row["SKU_TOTAL_LUCRO_BRUTO_VENDA"]} {row["CODIGO_FORMA_PAGAMENTO_VENDA"]} {row["NOME_FORMA_PAGAMENTO_VENDA"]} {row["CODIGO_BANCO_BANDEIRA_CARTAO_VENDA"]} {row["NOME_BANCO_BANDEIRA_CARTAO_VENDA"]} {row["TIPO_PARCELAMENTO_VENDA"]} {row["CPF_CNPJ_VENDA"]}, {row["SKU_DATA_COMPRA"]} {row["SKU_CODIGO_CFOP_COMPRA"]} {row["SKU_QUANTIDADE_COMPRA"]} {row["SKU_TOTAL_BRUTO_COMPRA"]} {row["SKU_TOTAL_DESCONTO_COMPRA"]} {row["SKU_TOTAL_LIQUIDO_COMPRA"]} {row["SKU_CUSTO_TOTAL_COMPRA"]} {row["SKU_CNPJ_FORNECEDOR_COMPRA"]} {row["SKU_NOME_FORNECEDOR_COMPRA"]} {row["SKU_QUANTIDADE_ESTOQUE"]} {row["SKU_CUSTO_ESTOQUE"]}'

            entry = prepare_record(
                {
                    "INSTRUCTION": f"{company_columns}",
                    "INPUT": None,
                    "RESPONSE": f"{company_columns} {product_columns} {channel_columns}",
                }
            )
            formatted_data.append(entry)

        return pd.DataFrame(formatted_data)


if __name__ == "__main__":

    records_df = insert_vectors()

    print(f"Prepared {len(records_df)} records for insertion.")

    vector_store.create_tables()
    vector_store.create_index()

    vector_store.upsert(records_df)

    print(f"Inserted {len(records_df)} records.")

# pylint: disable=C0114,C0115,C0116,C0301,W0611
import re
import unittest

# Import essential modules
import os
import json
import csv
import pandas as pd
from datasets import load_dataset, DatasetDict, concatenate_datasets


class DatasetTest(unittest.TestCase):

    _dir = os.path.dirname(__file__)
    _file = "SELLOUT_SELLIN_ESTOQUE_HISTORICO_26246169000110_20250606_032528_v02"

    _input_file_path = f"{_dir}/inputs/{_file}.xlsx"
    _output_file_path = f"{_dir}/outputs/{_file}"
    _output_file_ext = "csv"

    _sheet_name = "SELLOUT_SELLIN_ESTOQUE_HISTORIC"

    def _excel_to_json(self, input_file_path, json_file_path, sheet_name=None):
        df = pd.read_excel(input_file_path, sheet_name)
        json_data = df.to_json(orient="records", indent=4)

        with open(json_file_path, "w", encoding="utf-8") as f:
            f.write(json_data)

        print(f"Successfully converted '{input_file_path}' to '{json_file_path}'")

    def _excel_to_csv(self, input_file_path, txt_file_path):
        df = pd.read_excel(input_file_path)
        df.to_csv(txt_file_path, sep=",", index=False)

        print(f"Successfully converted '{input_file_path}' to '{txt_file_path}'")

    def _convert_to_alpaca_format(self, input_json_data):
        """
        Converts a given JSON dataset into the Stanford Alpaca format.

        Args:
            input_json_data (list or dict): The input JSON data.
                                            If a list, each element should be a dictionary
                                            containing fields that can be mapped to Alpaca's
                                            'instruction', 'input', and 'output'.
                                            If a dictionary, it's assumed to contain a list
                                            under a specific key (e.g., 'data').

        Returns:
            list: A list of dictionaries in the Alpaca format.
        """
        alpaca_formatted_data = []

        if isinstance(input_json_data, dict):
            # Assuming the actual data is under a key like 'data' or 'examples'
            if "data" in input_json_data:
                input_json_data = input_json_data["data"]
            elif "examples" in input_json_data:
                input_json_data = input_json_data["examples"]
            else:
                raise ValueError(
                    "Input dictionary does not contain a recognized data key (e.g., 'data', 'examples')."
                )

        for item in input_json_data:
            # Map your input JSON fields to Alpaca's 'instruction', 'input', 'output'
            # This mapping will depend on your specific input JSON structure.
            # Example:
            instruction = item.get("question", "")  # Assuming 'question' in your JSON
            input_context = item.get(
                "context", ""
            )  # Assuming 'context' in your JSON, can be empty
            output_answer = item.get("answer", "")  # Assuming 'answer' in your JSON

            alpaca_entry = {
                "instruction": instruction,
                "input": input_context,
                "output": output_answer,
            }
            alpaca_formatted_data.append(alpaca_entry)

        return alpaca_formatted_data

    def _convert_to_gpt_format(self, input_json_data, seed):
        """
        Converts a given JSON dataset into the GPT format.

        Args:
            input_json_data (list or dict): The input JSON data.
                                            If a list, each element should be a dictionary
                                            containing fields that can be mapped to GPT's
                                            'messages' structure.
                                            If a dictionary, it's assumed to contain a list
                                            under a specific key (e.g., 'data').

        Returns:
            list: A list of dictionaries in the GPT format.
        """
        formatted_data = []

        for i, item in enumerate(input_json_data):
            entry = {
                "conversation_id": f"{i + seed}",  # Adding a seed to ensure unique IDs
                "conversations": [
                    {"role": "user", "content": item["question"]},
                    {"role": "assistant", "content": item["answer"]},
                ],
            }
            formatted_data.append(entry)

        return formatted_data

    def test_create(self):

        # Convert Excel to csv
        self._excel_to_csv(
            self._input_file_path, f"{self._output_file_path}.{self._output_file_ext}"
        )

        # Convert Excel to json
        # self._excel_to_json(
        #     self._input_file_path, f"{self._output_file_path}.{self._output_file_ext}", self._sheet_name
        # )

        # Load Hugging Face dataset
        # huf_dataset = load_dataset(
        #     "nicholasKluge/instruct-aira-dataset-v2",
        #     split="portuguese",
        # )

        # Check Hugging Face dataset structure
        # print("Remote Dataset Structure:", huf_dataset)
        # print(huf_dataset["conversations"][0])

        # If the dataset has only one split, manually create a train/test split
        # if "train" not in dataset or "test" not in dataset:
        #     print(
        #         "🔹 Only one dataset split detected. Splitting into train/test manually..."
        #     )

        #     # Identify the correct single split (could be "train" or another name)
        #     split_name = list(dataset.keys())[0]
        #     dataset = dataset[split_name]  # Extract the only available split
        #     dataset = dataset.shuffle(seed=42)  # Shuffle the dataset

        #     # Split: 80% train, 20% test
        #     train_size = int(0.8 * len(dataset))
        #     dataset = DatasetDict(
        #         {
        #             "train": dataset.select(range(train_size)),
        #             "test": dataset.select(range(train_size, len(dataset))),
        #         }
        #     )

        # Apply formatting
        # fmt_dataset = dataset.map(
        #     self._format_conversation, remove_columns=dataset["train"].column_names
        # )

        # Save the dataset to JSON train/test split files
        # for key, dataset in dataset.items():
        #     output_file_name = f"{self._output_file_path}_{key}.json"
        #     dataset.to_json(output_file_name)

        # Convert to json format
        with open(
            f"{self._output_file_path}.{self._output_file_ext}",
            mode="r",
            encoding="utf-8",
        ) as infile:
            reader = csv.DictReader(infile, delimiter="," ,lineterminator="\n")

            with open(
                f"{self._output_file_path}.alpaca",
                mode="w",
                encoding="utf-8",
            ) as outfile:
                writer = csv.DictWriter(
                    outfile, fieldnames=["instruction", "input", "output"]
                )
                writer.writeheader()

                formatted_data = []

                for row in reader:
                    company_columns = f'{row["CODIGO_GRUPO_EMPRESARIAL_GE"]} {row["NOME_GE"]} {row["CODIGO_EMPRESA_GE"]} {row["NOME_EMPRESA_GE"]} {row["NOME_FANTASIA_EMPRESA_GE"]} {row["CNPJ_EMPRESA_GE"]}'
                    product_columns = f'{row["CODIGO_INTERNO_SKU"]} {row["NOME_SKU"]} {row["EAN_TEXTO_SKU"]} {row["EAN_NUMERICO_SKU"]} {row["EAN_PRINCIPAL_SKU"]} {row["UNIDADE_MEDIDA_SKU"]} {row["CODIGO_NCM_SKU"]} {row["CODIGO_CEST_SKU"]} {row["DATA_CADASTRO_SKU"]} {row["SITUACAO_SKU"]} {row["CODIGO_FABRICANTE_SKU"]} {row["NOME_FABRICANTE_SKU"]} {row["CODIGO_MARCA_SKU"]} {row["NOME_MARCA_SKU"]}'
                    channel_columns = f'{row["CODIGO_CANAL_VENDA"]} {row["NOME_CANAL_VENDA"]} {row["CODIGO_ORIGEM_VENDA"]} {row["NOME_ORIGEM_VENDA"]} {row["CODIGO_CFOP_VENDA"]} {row["ORDERID_CUPOM_VENDA"]} {row["SKU_DATA_VENDA"]} {row["SKU_QUANTIDADE_VENDA"]} {row["SKU_TOTAL_BRUTO_VENDA"]} {row["SKU_TOTAL_DESCONTO_VENDA"]} {row["SKU_TOTAL_LIQUIDO_VENDA"]} {row["SKU_PRECO_MEDIO_VENDA"]} {row["SKU_TOTAL_CMV_VENDA"]} {row["SKU_TOTAL_COMISSAO_VENDA"]} {row["SKU_TOTAL_BONIFICACAO_VENDA"]} {row["SKU_TOTAL_IMPOSTOS_VENDA"]} {row["SKU_TOTAL_LUCRO_BRUTO_VENDA"]} {row["CODIGO_FORMA_PAGAMENTO_VENDA"]} {row["NOME_FORMA_PAGAMENTO_VENDA"]} {row["CODIGO_BANCO_BANDEIRA_CARTAO_VENDA"]} {row["NOME_BANCO_BANDEIRA_CARTAO_VENDA"]} {row["TIPO_PARCELAMENTO_VENDA"]} {row["CPF_CNPJ_VENDA"]} {row["SKU_DATA_COMPRA"]} {row["SKU_CODIGO_CFOP_COMPRA"]} {row["SKU_QUANTIDADE_COMPRA"]} {row["SKU_TOTAL_BRUTO_COMPRA"]} {row["SKU_TOTAL_DESCONTO_COMPRA"]} {row["SKU_TOTAL_LIQUIDO_COMPRA"]} {row["SKU_CUSTO_TOTAL_COMPRA"]} {row["SKU_CNPJ_FORNECEDOR_COMPRA"]} {row["SKU_NOME_FORNECEDOR_COMPRA"]} {row["SKU_QUANTIDADE_ESTOQUE"]} {row["SKU_CUSTO_ESTOQUE"]}'

                    entry = {
                        "question": f"{company_columns}",
                        "answer": f"{company_columns} {product_columns} {channel_columns}",
                    }
                    formatted_data.append(entry)

                # file_formatted_data = self._convert_to_gpt_format(formatted_data, 0) # len(formatted_data)
                # outfile.write(json.dumps(gpt_formatted_data, indent=4))

                formatted_file = self._convert_to_alpaca_format(formatted_data)
                writer.writerows(formatted_file)

        # Load local dataset
        data_files = {
            "train": f"{self._dir}/outputs/{self._file}.alpaca"
        }
        dataset = load_dataset(
            "csv", data_dir=f"{self._dir}/outputs", data_files=data_files
        )

        # Check local dataset structure
        print("Local Dataset Structure:", dataset)
        # print("Data split:", dataset["train"][0])

        # dataset = DatasetDict(
        #     {"train": concatenate_datasets([huf_dataset, dataset["train"]])}
        # )

        # # Check merged dataset structure
        # print("Merged Dataset Structure:", dataset)

        # # Save the dataset to JSON train gpt format
        # serializable_dict = {key: dataset.to_dict() for key, dataset in dataset.items()}
        # json_string = json.dumps(serializable_dict, indent=4)

        # with open(f"{self._dir}/outputs/{self._file}.gpt", "w", encoding="utf-8") as f:
        #     f.write(json_string)

        # print(f"Saved {self._dir}/outputs/{self._file}.gpt")

if __name__ == "__main__":
    unittest.main()

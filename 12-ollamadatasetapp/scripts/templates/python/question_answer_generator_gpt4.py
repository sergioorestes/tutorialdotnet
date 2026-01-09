import os
import torch
import nltk
from nltk import sent_tokenize
from transformers import T5ForConditionalGeneration, T5Tokenizer, pipeline

nltk.download("punkt_tab")

# Define the directory path (use '.' for the current directory)
directory_path = "./input"
output_directory = "./output"

# Make sure the output directory exists
if not os.path.exists(output_directory):
    os.makedirs(output_directory)

# Load T5 model for question generation
t5_tokenizer = T5Tokenizer.from_pretrained("valhalla/t5-small-qg-hl")
t5_model = T5ForConditionalGeneration.from_pretrained("valhalla/t5-small-qg-hl")

# Load RoBERTa model for question answering
nlp_qa = pipeline(
    "question-answering",
    model="deepset/roberta-base-squad2",
    tokenizer="deepset/roberta-base-squad2",
)

# File to write the questions and answers
with open(
    os.path.join(output_directory, "questions_and_answers.txt"), "w", encoding="utf-8"
) as output_file:

    # Iterate through each file in the directory
    for filename in os.listdir(directory_path):
        file_path = os.path.join(directory_path, filename)

        # Check if the current item is a file
        if os.path.isfile(file_path):
            # Open and read the file
            with open(file_path, "r", encoding="utf-8") as file:
                file_content = file.read()

            # Tokenize into sentences
            sentences = sent_tokenize(file_content)

            # Process each sentence
            for sentence in sentences:
                # Generate questions
                input_text = "generate questions: " + sentence
                features = t5_tokenizer.encode(input_text, return_tensors="pt")
                output = t5_model.generate(
                    input_ids=features, max_length=20, num_return_sequences=1
                )
                question = t5_tokenizer.decode(output[0], skip_special_tokens=True)

                # Extract answer
                answer = nlp_qa(question=question, context=sentence)["answer"]

                # Filtering for low-quality pairs
                if answer.lower() not in question.lower() and len(answer.split()) > 1:
                    # Write the question and answer to the file
                    output_file.write(f"Question: {question}\n")
                    output_file.write(f"Answer: {answer}\n\n")

print(
    f"Questions and answers have been saved in {output_directory}/questions_and_answers.txt"
)

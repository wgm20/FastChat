#!/bin/bash

# Ask the user for the model name
echo "Please enter the model name:"
read MODEL_NAME

# Check if MODEL_NAME is set
if [ -z "$MODEL_NAME" ]; then
    echo "Error: MODEL_NAME is not set."
    exit 1
fi

# Navigate to the desired directory in one step (adjust the path as needed)
# assumes we are in the directory the file is in and venv is a the same level as this is checked out to. 
cd ./../../venv/bin/ || exit

# Activate the environment
source activate || exit

# Return to the llm_judge directory
cd ../../FastChat/fastchat/llm_judge || exit

# Run the model answer generation
python gen_model_answer.py --model-path camilloai/${MODEL_NAME} --model-id ${MODEL_NAME} --dtype bfloat16 || exit

# need openai key here. 

# Run the judgment script
python gen_judgment.py --model-list ${MODEL_NAME} --parallel 2 || exit

# Display the result
python show_result.py || exit
#!/bin/bash

# Ask the user for the model name
echo "Please enter the model name:  e.g. Cargen-DPO-1-c-TD "
read MODEL_NAME

# Check if MODEL_NAME is set
if [ -z "$MODEL_NAME" ]; then
    echo "Error: MODEL_NAME is not set."
    exit 1
fi

# Ask the user for the OpenAI API key
echo "Please enter your OpenAI API key:"
read -s OPENAI_API_KEY  # '-s' flag hides the input for privacy


# Check if OPENAI_API_KEY is set
if [ -z "$OPENAI_API_KEY" ]; then
    echo "Error: OPENAI_API_KEY is not set."
    exit 1
fi

# Navigate to the desired directory in one step (adjust the path as needed)
cd ./../../venv/bin/ || exit

# Activate the environment
source activate || exit

#pip install ray

# Return to the llm_judge directory
cd ../../FastChat/fastchat/llm_judge || exit

# Export the OpenAI API key
export OPENAI_API_KEY

# Run the model answer generation
python gen_model_answer.py --model-path camilloai/${MODEL_NAME} --model-id ${MODEL_NAME} --dtype bfloat16 --num-gpus-total 8 || exit

# Run the judgment script
python gen_judgment.py --model-list ${MODEL_NAME} --parallel 2 || exit

# Display the result
python show_result.py || exit

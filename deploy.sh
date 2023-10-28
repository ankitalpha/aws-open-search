#!/bin/bash

lambda_function_dir="lambda_function"
zip_file="lambda_code.zip"

# Create a virtual environment
python3 -m venv "$lambda_function_dir/venv"

# Activate the virtual environment
source "$lambda_function_dir/venv/bin/activate"

# Install dependencies
pip install -r "$lambda_function_dir/requirements.txt"

# Deactivate the virtual environment
deactivate

# Zip the Lambda function code and dependencies
cd "$lambda_function_dir"
zip -r "../$zip_file" .
cd ..

echo "Lambda function code zipped successfully to $zip_file"

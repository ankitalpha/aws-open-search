resource "aws_lambda_function" "log_ingest_lambda" {
  # Lambda function configuration
  function_name = var.function_name
  runtime       = var.runtime
  handler       = var.handler
  timeout       = var.timeout
  memory_size   = var.memory_size

  # Add IAM role ARN for Lambda execution
  role = var.iam_role_arn
  source_code_hash = filebase64(var.lambda_code_path)  # Use the contents of the ZIP file
  # Add your Lambda function code in a separate file (e.g., lambda_code.zip)
  filename = var.lambda_code_path

    environment {
      variables = {
        opensearch_endpoint = var.opensearch_endpoint
    }
  }
}

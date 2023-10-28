output "log_ingest_lambda_arn" {
  value = aws_lambda_function.log_ingest_lambda.arn
}

output "lambda_function_name" {
  value = aws_lambda_function.log_ingest_lambda.function_name
}

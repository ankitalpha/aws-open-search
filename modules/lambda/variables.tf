variable "function_name" {
  description = "Name of the Lambda function"
}

variable "runtime" {
  description = "Runtime for the Lambda function"
}

variable "handler" {
  description = "Handler function for the Lambda"
}

variable "timeout" {
  description = "Timeout for the Lambda function"
}

variable "memory_size" {
  description = "Memory size for the Lambda function"
}

variable "iam_role_arn" {
  description = "ARN of the IAM role for Lambda execution"
}

variable "lambda_code_path" {
  description = "Path to the Lambda function code zip file"
}

variable "opensearch_endpoint" {
  description = "The endpoint of the OpenSearch cluster"
  type        = string
}
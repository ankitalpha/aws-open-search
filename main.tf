# provider "aws" {
#   region = "us-east-1"
# }

# module "opensearch" {
#   source        = "./modules/opensearch"
#   domain_name   = "finnoto-opensearch-domain" 
#   instance_type = "t2.small.search"
#   volume_size   = 10
# }

# module "s3" {
#   source      = "./modules/s3"
#   bucket_name = "finnoto-logs-s3"
# }

# module "lambda" {
#   source           = "./modules/lambda"
#   function_name    = "log_ingest_lambda"
#   runtime          = "python3.8"
#   handler          = "handler.lambda_handler"
#   timeout          = 60
#   memory_size      = 256
#   iam_role_arn     = module.opensearch.opensearch_role_arn
#   lambda_code_path = "./lambda_code.zip"
#   opensearch_endpoint = module.opensearch.opensearch_endpoint
# }

# module "s3_event" {
#   source     = "./modules/s3_event"
#   s3_bucket_name = module.s3.bucket_name
#   bucket_id  = module.s3.logs_bucket_id
#   lambda_arn = module.lambda.log_ingest_lambda_arn
# }



# =======>=======>=======>=======>=======>=======>=======>=======>=======>=======>

provider "aws" {
  region = "ap-south-1" # Change to your desired AWS region
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "ap-south-1"
}


# Create S3 bucket to store logs
resource "aws_s3_bucket" "logs_bucket" {
  bucket = "finnoto-logs-bucket"
}

# IAM Role for Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_opensearch_integration_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Lambda function to push logs from S3 to OpenSearch
resource "aws_lambda_function" "log_push_lambda" {
  function_name = "log_push_to_opensearch"
  handler       = "index.handler" # Modify based on your Lambda function
  runtime       = "python3.8"     # Modify based on your Lambda function

  role          = aws_iam_role.lambda_role.arn
  # You will need to point to your lambda deployment package
  filename      = "./lambda_code.zip"

  # environment {
  #   variables = {
  #     OPENSEARCH_ENDPOINT = aws_opensearch_domain.example.endpoint
  #   }
  # }
}

# IAM Role for OpenSearch
resource "aws_iam_role" "opensearch_role" {
  name = "opensearch_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "es.amazonaws.com"
        }
      }
    ]
  })
}

# Define IAM policy document for OpenSearch
data "aws_iam_policy_document" "opensearch_access" {
  statement {
    actions   = ["es:*"]
    resources = ["arn:aws:es:${var.aws_region}:037822678291:domain/my-opensearch-domain"]
  }
}


# OpenSearch Domain
resource "aws_opensearch_domain" "example" {
  domain_name = "my-opensearch-domain"
  node_to_node_encryption {
    enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  cluster_config {
    instance_type = "t2.small.search"
  }

  access_policies = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          AWS = "*"
        },
        Action   = "es:*",
        Resource = "arn:aws:es:ap-south-1:037822678291:domain/my-opensearch-domain/*",
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "122.171.16.45"
          }
        }
      },
      {
        Effect    = "Allow",
        Principal = {
          AWS = "*"
        },
        Action   = "es:*",
        Resource = "arn:aws:es:ap-south-1:037822678291:domain/my-opensearch-domain/*",
        Condition = {
          IpAddress = {
            "aws:SourceIp" = "122.166.45.187"
          }
        }
      }
    ]
  })
}

# output "opensearch_endpoint" {
#   value = aws_opensearch_domain.example.endpoint
# }

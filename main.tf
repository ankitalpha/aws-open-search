provider "aws" {
  region = "us-east-1"
}

module "opensearch" {
  source        = "./modules/opensearch"
  domain_name   = "finnoto-opensearch-domain" 
  instance_type = "t2.small.search"
  volume_size   = 10
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "finnoto-logs-s3"
}

module "lambda" {
  source           = "./modules/lambda"
  function_name    = "log_ingest_lambda"
  runtime          = "python3.8"
  handler          = "handler.lambda_handler"
  timeout          = 60
  memory_size      = 256
  iam_role_arn     = module.opensearch.opensearch_role_arn
  lambda_code_path = "./lambda_code.zip"
  opensearch_endpoint = module.opensearch.opensearch_endpoint
}

module "s3_event" {
  source     = "./modules/s3_event"
  s3_bucket_name = module.s3.bucket_name
  bucket_id  = module.s3.logs_bucket_id
  lambda_arn = module.lambda.log_ingest_lambda_arn
}

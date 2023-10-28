resource "aws_cloudwatch_event_rule" "logs_bucket_rule" {
  name                = "logs_bucket_rule"
  event_pattern       = jsonencode({
    source      = ["aws.s3"],
    detail      = {
      eventName   = ["PutObject", "CompleteMultipartUpload"],
      requestParameters = {
        bucketName = [var.s3_bucket_name]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "logs_bucket_target" {
  rule      = aws_cloudwatch_event_rule.logs_bucket_rule.name
  target_id = "logs_bucket_target"

  arn = var.lambda_arn  
}


resource "aws_s3_bucket_notification" "logs_bucket_notification" {
  bucket = var.bucket_id

  lambda_function {
    lambda_function_arn = var.lambda_arn
    events             = ["s3:ObjectCreated:*"]
  }
}


output "s3_event_rule_arn" {
  value = aws_cloudwatch_event_rule.logs_bucket_rule.arn
}
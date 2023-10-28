output "opensearch_domain_endpoint" {
  value = aws_opensearch_domain.example.endpoint
}

output "opensearch_domain_arn" {
  value = aws_opensearch_domain.example.arn
}

output "opensearch_role_arn" {
  value = aws_iam_role.opensearch_role.arn
}

output "opensearch_endpoint" {
  value = aws_opensearch_domain.example.endpoint
}

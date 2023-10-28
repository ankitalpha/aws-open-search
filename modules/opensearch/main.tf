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

resource "aws_opensearch_domain" "example" {
  domain_name = var.domain_name

  cluster_config {
    instance_type = var.instance_type
  }

  access_policies = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "es.amazonaws.com"
        },
        Action = "es:*",
        # Resource = aws_opensearch_domain.example.arn,
      },
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
        # Resource = aws_opensearch_domain.example.endpoint,
      },
    ]
  })

  ebs_options {
    ebs_enabled = true
    volume_size = var.volume_size
  }

}
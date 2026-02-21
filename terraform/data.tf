data "aws_secretsmanager_secret" "client_secret" {
  # Use the name of your secret as it appears in AWS Secrets Manager
  name = "google_client_secret"
}

data "aws_secretsmanager_secret_version" "client_secret" {
  secret_id = data.aws_secretsmanager_secret.client_secret.id
}

data "aws_secretsmanager_secret" "argocd_client_secret" {
  # Use the name of your secret as it appears in AWS Secrets Manager
  name = "argocd_client_secret"
}

data "aws_secretsmanager_secret_version" "argocd_client_secret" {
  secret_id = data.aws_secretsmanager_secret.argocd_client_secret.id
}

data "aws_acm_certificate" "alb_cert" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "argocd_cert" {
  domain   = var.argocd_domain_name
  statuses = ["ISSUED"]
}
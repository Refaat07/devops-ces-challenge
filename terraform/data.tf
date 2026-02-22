# Application Client Secret from AWS Secrets Manager
data "aws_secretsmanager_secret" "client_secret" {
  name = "google_client_secret"
}

data "aws_secretsmanager_secret_version" "client_secret" {
  secret_id = data.aws_secretsmanager_secret.client_secret.id
}

# ArgoCD Client Secret from AWS Secrets Manager
data "aws_secretsmanager_secret" "argocd_client_secret" {
  name = "argocd_client_secret"
}

data "aws_secretsmanager_secret_version" "argocd_client_secret" {
  secret_id = data.aws_secretsmanager_secret.argocd_client_secret.id
}

# ACM certificates for ALB
data "aws_acm_certificate" "alb_cert" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

data "aws_acm_certificate" "argocd_cert" {
  domain   = var.argocd_domain_name
  statuses = ["ISSUED"]
}
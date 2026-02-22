module "vpc" {
  source                         = "./modules/vpc"
  vpc_cidr_block                 = "10.0.0.0/23"
  public_snet_cidr_block         = "10.0.0.0/24"
  private_snet_cidr_block        = "10.0.1.0/24"
  public_snet_availability_zone  = "eu-central-1a"
  private_snet_availability_zone = "eu-central-1b"
  cluster_name                   = "${var.env_name}-eks"
  alb_name                       = "${var.env_name}-eks-alb"
}

module "eks" {
  source                  = "./modules/eks"
  cluster_name            = "${var.env_name}-eks"
  cluster_version         = "1.34"
  cluster_role_name       = "${var.env_name}-eks-role"
  alb_name                = "${var.env_name}-eks-alb"
  alb_sg_id               = module.vpc.alb_sg_id
  node_group_role_name    = "${var.env_name}-node-group-role"
  authentication_mode     = "API_AND_CONFIG_MAP"
  vpc_id                  = module.vpc.vpc_id
  subnet_ids              = [module.vpc.public_snet_id, module.vpc.private_snet_id]
  certificate_arn         = data.aws_acm_certificate.alb_cert.arn
  endpoint_public_access  = true
  endpoint_private_access = true
  client_id               = var.client_id
  oauth2_issuer_url       = var.oauth2_issuer_url
  authorization_url       = var.authorization_url
  user_info_endpoint      = var.user_info_endpoint
  token_url               = var.token_url
  client_secret           = data.aws_secretsmanager_secret_version.client_secret.secret_string
}

module "helm_charts" {
  source                 = "./modules/helm"
  subnet_ids             = [module.vpc.public_snet_id, module.vpc.private_snet_id]
  vpc_id                 = module.vpc.vpc_id
  alb_name               = "argocd-alb"
  alb_sg_id              = module.vpc.alb_sg_id # Same SG for EKS ALB
  autoscaling_group_name = module.eks.autoscaling_group_name
  certificate_arn        = data.aws_acm_certificate.argocd_cert.arn
  client_id              = var.argocd_client_id
  client_secret          = data.aws_secretsmanager_secret_version.argocd_client_secret.secret_string
  argocd_domain_name     = var.argocd_domain_name
  depends_on             = [module.eks]
}

module "vpc" {
  source                         = "./modules/vpc"
  vpc_cidr_block                 = "10.0.0.0/23"
  public_snet_cidr_block         = "10.0.0.0/24"
  private_snet_cidr_block        = "10.0.1.0/24"
  public_snet_availability_zone  = "eu-central-1a"
  private_snet_availability_zone = "eu-central-1b"
}

module "eks" {
  source                  = "./modules/eks"
  cluster_name            = "${var.env_name}-eks"
  cluster_version         = "1.34"
  cluster_role_name       = "${var.env_name}-eks-role"
  node_group_role_name    = "${var.env_name}-node-group-role"
  authentication_mode     = "API_AND_CONFIG_MAP"
  subnet_ids              = [module.vpc.public_snet_id, module.vpc.private_snet_id]
  depends_on              = [module.vpc]
  endpoint_public_access  = true #TODO: If time allows, set to false and configure access via bastion host or VPN
  endpoint_private_access = true
}
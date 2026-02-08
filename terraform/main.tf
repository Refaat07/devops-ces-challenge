module "vpc" {
  source                  = "./modules/vpc"
  vpc_cidr_block          = var.vpc_cidr_block
  snet1_cidr_block        = var.snet1_cidr_block
  snet1_availability_zone = var.snet1_availability_zone
  snet2_cidr_block        = var.snet2_cidr_block
  snet2_availability_zone = var.snet2_availability_zone
}

module "eks" {
  source                    = "./modules/eks"
  cluster_name              = var.cluster_name
  cluster_role_name         = var.cluster_role_name
  node_group_role_name      = var.node_group_role_name
  authentication_mode       = var.cluster_authentication_mode
  subnet_ids                = module.vpc.subnet_ids
  depends_on = [ module.vpc ]
}
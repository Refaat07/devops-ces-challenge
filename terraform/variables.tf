variable "region" {
  description = "Default Region for AWS resources"
  default     = "eu-central-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/23"
}

variable "creds_profile" {
  description = "AWS credentials profile to use"
  default     = "default"
}

variable "snet1_cidr_block" {
  type        = string
  description = "Subnet 1 CIDR block"
  default     = "10.0.0.0/24"
}

variable "snet1_availability_zone" {
  type        = string
  description = "Subnet 1 CIDR block"
  default     = "eu-central-1a"
}

variable "snet2_cidr_block" {
  type        = string
  description = "Subnet 2 CIDR block"
  default     = "10.0.1.0/24"
}

variable "snet2_availability_zone" {
  type        = string
  description = "Subnet 2 CIDR block"
  default     = "eu-central-1b"
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name"
  default     = "dv-eks"
}

variable "cluster_authentication_mode" {
  type        = string
  description = "EKS Cluster Authentication Mode"
  default     = "API_AND_CONFIG_MAP"
}

variable "cluster_role_name" {
  type        = string
  description = "EKS Role Name"
  default     = "dv-eks-role"
}

variable "node_group_role_name" {
  type        = string
  description = "EKS Role Name"
  default     = "dv-eks-node-group-role"
}
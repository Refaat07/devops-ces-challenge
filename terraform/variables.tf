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

variable "snet_cidr_blocks" {
  type        = list(string)
  description = "Subnet CIDR blocks"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "snet_availability_zones" {
  type        = list(string)
  description = "Subnet Availability Zones"
  default     = ["eu-central-1a", "eu-central-1b"]
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
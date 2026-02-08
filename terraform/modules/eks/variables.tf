variable "cluster_name" {
  type = string
  description = "EKS Cluster Name"
  default = "dv-eks"
}

variable "authentication_mode" {
  type = string
  description = "EKS Cluster Authentication Mode"
  default = "API_AND_CONFIG_MAP"
  }

variable "cluster_role_name" {
  type = string
  description = "EKS Role Name"
  default = "dv-eks-role"
}

variable "node_group_role_name" {
  type = string
  description = "EKS Role Name"
  default = "dv-eks-node-group-role"
}

variable "subnet_ids" {
  type = list(string)
  description = "List of subnet IDs for the EKS cluster"
  default = null
}
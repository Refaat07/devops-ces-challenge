variable "cluster_name" {
  type = string
  description = "EKS Cluster Name"
  default = "dv-eks"
}
variable "cluster_version" {
  type        = string
  description = "EKS Cluster version"
  default     = "1.31"
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

variable endpoint_public_access {
  type        = bool
  description = "Public access to the EKS cluster endpoint"
  default     = false
}

variable endpoint_private_access {
  type        = bool
  description = "Private access to the EKS cluster endpoint"
  default     = true
}
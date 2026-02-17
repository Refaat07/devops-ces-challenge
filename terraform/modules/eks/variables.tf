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

variable "vpc_id" {
  type = string
  description = "VPC ID for the EKS cluster"
  default = "main"
}

variable "alb_name" {
  type = string
  description = "Name of the Application Load Balancer"
  default = "eks-alb"
}

variable "alb_sg_id" {
  type = string
  description = "Security group ID for the Application Load Balancer"
  default = "eks-alb-sg"
}

variable "certificate_arn" {
  type = string
  description = "ARN of the ACM certificate for the ALB"
  default = ""
}

variable "oauth2_issuer_url" {
  type = string
  description = "OAuth2 Issuer URL"
  default = "https://token.actions.githubusercontent.com"
}

variable "authorization_url" {
  type = string
  description = "OAuth2 Authorization URL"
  default = "https://github.com/login/oauth/authorize"
}

variable "token_url" {
  type = string
  description = "OAuth2 Token URL"
  default = "https://github.com/login/oauth/access_token"
}
variable "user_info_endpoint" {
  type = string
  description = "OAuth2 User Info Endpoint"
  default = "https://api.github.com/user"
}
variable "client_id" {
  type = string
  description = "OAuth2 Client ID"
  sensitive = true
}

variable "client_secret" {
  type = string
  description = "OAuth2 Client Secret"
  sensitive = true
}
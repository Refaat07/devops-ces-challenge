variable "subnet_ids" {
  type = list(string)
  description = "List of subnet IDs for the ArgoCD cluster"
  default = null
}

variable "vpc_id" {
  type = string
  description = "VPC ID for the ArgoCD cluster"
  default = "main"
}

variable "alb_name" {
  type = string
  description = "Name of the Application Load Balancer"
  default = "argocd-alb"
}

variable "alb_sg_id" {
  type = string
  description = "Security group ID for the Application Load Balancer"
  default = "eks-alb-sg"
}
variable "autoscaling_group_name" {
  type = string
  description = "Name of the Autoscaling group for the EKS node group"
  default = "eks_node_group"
}
variable "certificate_arn" {
  type = string
  description = "ARN of the ACM certificate for the ArgoCD ALB"
  default = ""
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
variable "vpc_cidr_block" {
  type = string
  description = "VPC CIDR block"
  default = "10.0.0.0/23"
}

variable "public_snet_cidr_block" {
  type        = string
  description = "Public Subnet CIDR block"
  default     = "10.0.0.0/24"
}

variable "public_snet_availability_zone" {
  type        = string
  description = "Public Subnet Availability Zone"
  default     = "eu-central-1a"
}

variable "private_snet_cidr_block" {
  type        = string
  description = "Private Subnet CIDR block"
  default     = "10.0.1.0/24"
}

variable "private_snet_availability_zone" {
  type        = string
  description = "Private Subnet Availability Zone"
  default     = "eu-central-1b"
}

variable "cluster_name" {
  type        = string
  description = "Private Subnet Availability Zone"
  default     = "dv-eks"
}
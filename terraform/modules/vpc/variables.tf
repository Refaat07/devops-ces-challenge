variable "vpc_cidr_block" {
  type = string
  description = "VPC CIDR block"
  default = "10.0.0.0/23"
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
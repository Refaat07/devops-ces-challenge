variable "vpc_cidr_block" {
  type = string
  description = "VPC CIDR block"
  default = "10.0.0.0/23"
}

variable "snet1_cidr_block" {
  type = string
  description = "Subnet 1 CIDR block"
  default = "10.0.0.0/24"
}

variable "snet1_availability_zone" {
  type = string
  description = "Subnet 1 CIDR block"
  default = "eu-central-1a"
}

variable "snet2_cidr_block" {
  type = string
  description = "Subnet 2 CIDR block"
  default = "10.0.1.0/24"
}

variable "snet2_availability_zone" {
  type = string
  description = "Subnet 2 CIDR block"
  default = "eu-central-1b"
}
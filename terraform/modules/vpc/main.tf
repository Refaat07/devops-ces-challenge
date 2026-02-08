# Main VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

# Subnets for use with EKS
resource "aws_subnet" "snets" {
  for_each = toset(var.snet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
availability_zone = var.snet_availability_zones[index(var.snet_cidr_blocks, each.value)]
}


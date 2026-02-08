# Main VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

# Subnets for use with EKS
resource "aws_subnet" "snets" {
  for_each = zipmap(var.snet_cidr_blocks, var.snet_availability_zones) #construced map of cidr blocks and availability zones as keys and values respectively
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.key
  availability_zone = each.value
}


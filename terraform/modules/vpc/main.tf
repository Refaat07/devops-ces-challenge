# Main VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

# Subnets for use with EKS
resource "aws_subnet" "snet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.snet1_cidr_block
  availability_zone = var.snet1_availability_zone
}

resource "aws_subnet" "snet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.snet2_cidr_block
  availability_zone = var.snet2_availability_zone
}
# Main VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
}

# Subnets for use with EKS
resource "aws_subnet" "public_snet"{
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_snet_cidr_block
  availability_zone = var.public_snet_availability_zone
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "private_snet"{
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_snet_cidr_block
  availability_zone = var.private_snet_availability_zone
   tags = {
    Name = "${var.cluster_name}-node-group",
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.main.id
  }
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  depends_on = [aws_internet_gateway.main]
}

# NAT Gateway in public subnet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_snet.id
  depends_on = [aws_internet_gateway.main]
}

# Private route to NAT Gateway for internet access
resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_snet.id
  route_table_id = aws_route_table.public.id
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_snet.id
  route_table_id = aws_route_table.private.id
}
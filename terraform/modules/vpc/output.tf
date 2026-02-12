output "vpc_arn" {
  value = aws_vpc.main.arn
}
output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_snet_arn" {
  value = aws_subnet.public_snet.arn
}

output "public_snet_id" {
  value = aws_subnet.public_snet.id
}

output "private_snet_arn" {
  value = aws_subnet.private_snet.arn
}

output "private_snet_id" {
  value = aws_subnet.private_snet.id
}

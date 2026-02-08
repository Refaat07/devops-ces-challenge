output "vpc_arn" {
  value = aws_vpc.main.arn
}
output "vpc_id" {
  value = aws_vpc.main.id
}
output "subnet_ids" {
  value = [for snet in aws_subnet.snets : snet.id]
}

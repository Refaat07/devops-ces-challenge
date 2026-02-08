output "vpc_arn" {
  value = aws_vpc.main.arn
}
output "vpc_id" {
  value = aws_vpc.main.id
}
output "subnet_ids" {
  value = [aws_subnet.snet1.id, aws_subnet.snet2.id]
}

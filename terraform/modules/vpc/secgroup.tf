# resource "aws_security_group" "eks_cluster_sg" {
#   name        = "${var.cluster_name}-sg"
#   description = "Security group for EKS cluster control plane"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
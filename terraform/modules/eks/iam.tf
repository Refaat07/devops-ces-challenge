# Cluster IAM Role
resource "aws_iam_role" "cluster_role" {
  name = var.cluster_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

# Attach the AmazonEKSClusterPolicy to the EKS IAM Role
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
  depends_on = [ aws_iam_role.cluster_role ]
}

# EKS Node Group IAM Role
resource "aws_iam_role" "eks_node_group_role" {
  name = var.node_group_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AmazonEKSWorkerNodePolicy to the EKS Node Group IAM Role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_attachment" {
  for_each = toset(["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
                "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
                "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"])
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = each.value
}

# Create a managed policy with additional permissions for the EKS Node Group IAM Role
resource "aws_iam_policy" "eks_node_additional_permissions" {
  name        = "${var.node_group_role_name}-additional-permissions"
  description = "Additional permissions for EKS node group"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:DetachNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach the additional permissions policy to the EKS Node Group IAM Role
resource "aws_iam_role_policy_attachment" "eks_node_additional_permissions_attachment" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = aws_iam_policy.eks_node_additional_permissions.arn
}


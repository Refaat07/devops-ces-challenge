# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name

  access_config {
    authentication_mode = var.authentication_mode
  }

  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

# EKS Node Group
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy_attachment,
    aws_eks_cluster.eks_cluster,
  ]
  
}

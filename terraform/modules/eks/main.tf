# EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
  bootstrap_self_managed_addons = true
  access_config {
    authentication_mode = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = true
  }

  role_arn = aws_iam_role.cluster_role.arn
  version  = var.cluster_version
  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
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
  subnet_ids      = [var.subnet_ids[1]] # Use private subnet for node group
  instance_types = ["t3.small"]
  # ami_type = "BOTTLEROCKET_x86_64"

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
  tags = {
    Name = "${var.cluster_name}-node-group",
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
  
}

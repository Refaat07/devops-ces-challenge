output "eks_role" {
  value = aws_iam_role.cluster_role.arn
}
output "eks_node_group_role" {
  value = aws_iam_role.eks_node_group_role.arn
}
output "eks_role" {
  value = aws_iam_role.cluster_role.arn
}
output "eks_node_group_role" {
  value = aws_iam_role.eks_node_group_role.arn
}
output "eks_cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}
output "alb_dns_name" {
  value       = aws_lb.eks_alb.dns_name
  description = "DNS name of the Application Load Balancer"
}

output "autoscaling_group_name" {
  value = aws_eks_node_group.eks_node_group.resources[0].autoscaling_groups[0].name
  description = "Autoscaling Group name"
}
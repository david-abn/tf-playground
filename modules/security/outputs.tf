output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_sg_internal_id" {
  value = aws_security_group.alb_sg_internal.id
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_nodes_role_arn" {
  value = aws_iam_role.eks_nodes_role.arn
}

output "eks_cluster_sg_id" {
  value = aws_security_group.eks_cluster_sg.id
}

output "eks_nodes_sg_id" {
  value = aws_security_group.eks_nodes_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}

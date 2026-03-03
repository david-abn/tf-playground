resource "aws_eks_cluster" "main" {
  name     = "${var.env}-eks-cluster"
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids              = concat(var.private_subnet_ids, var.public_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [var.eks_cluster_sg_id]
  }
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.env}-node-group"
  node_role_arn   = var.eks_nodes_role_arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = 3
    min_size     = 3
    max_size     = 6
  }
}

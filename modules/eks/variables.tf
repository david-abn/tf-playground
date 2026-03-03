variable "env" {
  description = "Environment name"
  type        = string
}

variable "eks_cluster_role_arn" {
  description = "EKS Cluster Role ARN"
  type        = string
}

variable "eks_nodes_role_arn" {
  description = "EKS Nodes Role ARN"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "instance_type" {
  description = "EKS node instance type"
  type        = string
}

variable "eks_cluster_sg_id" {
  description = "EKS Cluster Security Group ID"
  type        = string
}

variable "eks_nodes_sg_id" {
  description = "EKS Nodes Security Group ID"
  type        = string
}

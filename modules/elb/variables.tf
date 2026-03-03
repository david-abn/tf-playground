variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB Security Group"
  type        = string
}

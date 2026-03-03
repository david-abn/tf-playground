terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "my-tf-state-bucket-abroodav"
    key            = "playground/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf-state-lock"
  }

}

provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source             = "../../modules/networking"
  vpc_cidr           = var.vpc_cidr
  single_nat_gateway = var.single_nat_gateway
  env                = var.env
}

module "security" {
  source   = "../../modules/security"
  vpc_id   = module.networking.vpc_id
  vpc_cidr = var.vpc_cidr
  env      = var.env
}

module "elb" {
  source            = "../../modules/elb"
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  env               = var.env

}

module "eks" {
  source               = "../../modules/eks"
  env                  = var.env
  eks_cluster_role_arn = module.security.eks_cluster_role_arn
  eks_nodes_role_arn   = module.security.eks_nodes_role_arn
  public_subnet_ids    = module.networking.public_subnet_ids
  private_subnet_ids   = module.networking.private_subnet_ids
  instance_type        = var.instance_type
  eks_cluster_sg_id    = module.security.eks_cluster_sg_id
  eks_nodes_sg_id      = module.security.eks_nodes_sg_id
}

module "db" {
  source             = "../../modules/db"
  env                = var.env
  private_subnet_ids = module.networking.private_subnet_ids
  db_sg_id           = module.security.db_sg_id
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
}

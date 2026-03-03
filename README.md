# Terraform AWS Infrastructure Playground

Personal learning project demonstrating Infrastructure as Code using Terraform to deploy a production-like AWS environment.

## Architecture

Multi-tier AWS infrastructure with:

- **Networking**: VPC with public/private subnets across 3 AZs, NAT Gateway, Internet Gateway
- **Compute**: EKS cluster with managed node groups (t3.micro instances)
- **Database**: RDS PostgreSQL (db.t3.micro)
- **Load Balancing**: Application Load Balancer
- **Security**: IAM roles, security groups with least-privilege access

## Structure

```
├── modules/ # Reusable Terraform modules
│ ├── networking/ # VPC, subnets, routing
│ ├── security/ # Security groups, IAM roles
│ ├── eks/ # EKS cluster and node groups
│ ├── elb/ # Application Load Balancer
│ └── db/ # RDS PostgreSQL
├── environments/
│ └── dev/ # Development environment
└── global/
└── s3/ # Remote state backend
```

## Features

- Remote state management with S3 + DynamoDB locking
- Modular design for reusability
- Multi-AZ deployment for high availability
- SSM Session Manager enabled for EKS nodes
- Cost-optimized for learning (single NAT, t3.micro instances)

## Usage

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = "lb-aws-admin"
}

####################
# 1. Locals & Data #
####################

locals {
  common_tags = {
    Terraform   = "true"
    Environment = var.environment
  }
}

data "aws_availability_zones" "available" {}

#####################
# 2. VPC Definition #
#####################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "aiops-eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = merge(local.common_tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
}

##########################
# 3. IAM Role for Access #
##########################

resource "aws_iam_role" "eks_admin_role" {
  name = "eks-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::631737274131:root"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

#####################
# 4. EKS Deployment #
#####################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa = true

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  eks_managed_node_groups = {
    default = {
      instance_types = [var.node_instance_type]
      desired_size   = var.desired_capacity
      max_size       = var.max_capacity
      min_size       = var.min_capacity
    }
  }

  tags = local.common_tags
}

##################################
# 5. EKS Access Entry & Policies #
##################################

resource "aws_eks_access_entry" "admin" {
  cluster_name   = module.eks.cluster_name
  principal_arn  = aws_iam_role.eks_admin_role.arn
  type           = "STANDARD"

  tags = local.common_tags

  depends_on = [module.eks]
}
resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.eks_admin_role.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.admin]
}
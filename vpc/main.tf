   
provider "aws" {
  region = local.region
}

locals {
  region    = "us-east-2"
  vpc_name  = "vpc-kube"
  sg_name   = "sgroup-kube"
  tags      = {
    "env"   = "sbox"
  }
  egress_rules      = ["all-all"]
}


################################################################################
# VPC Module
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = "vpc-kube"
  cidr = "172.28.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["172.28.1.0/24", "172.28.2.0/24", "172.28.3.0/24"]
  public_subnets  = ["172.28.129.0/24", "172.28.130.0/24", "172.28.131.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags 

  vpc_tags = {
    Name = "vpc-kube"
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name               = local.sg_name
  description        = "Security group to use with K8s EC2 instances"
  vpc_id             = module.vpc.vpc_id
  ingress_with_cidr_blocks = var.sgroup_kube_ingress_with_cidr_blocks
  egress_rules      = local.egress_rules
  tags = local.tags
}

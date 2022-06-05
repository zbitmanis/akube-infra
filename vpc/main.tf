   
provider "aws" {
  region = local.region
}

locals {
  region = "us-east-2"
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

  tags = {
    env = "sbox"
  }

  vpc_tags = {
    Name = "vpc-kube"
  }
}

   
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
 ingress_rule_allow_ssh = [{
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh admin access"
      cidr_blocks = "${data.external.get_ip_addres_using_shell.result.ip_address}/32"
    },{
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      description = "k8s API  access"
      cidr_blocks = "${data.external.get_ip_addres_using_shell.result.ip_address}/32"
    }]
 ingress_rules     = concat (var.sgroup_kube_ingress_with_cidr_blocks, local.ingress_rule_allow_ssh) 
 egress_rules      = ["all-all"]
 general_private_subnet_tags = {"kubernetes.io/role/internal-elb" =  "1"}
 general_public_subnet_tags  = { "kubernetes.io/role/elb" = "1" }
 private_subnet_tags = merge(local.general_private_subnet_tags, var.private_subnet_tags)
 public_subnet_tags  = merge(local.general_public_subnet_tags, var.public_subnet_tags) 
 
 private_subnets = [for i in var.private_subnets_indexes : {
      value          = var.private_subnets[0]
    }
  ]

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
  
  private_subnet_tags = local.private_subnet_tags  
  public_subnet_tags = local.public_subnet_tags  

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
  ingress_with_cidr_blocks = local.ingress_rules     
  egress_rules      = local.egress_rules
  tags = local.tags
}

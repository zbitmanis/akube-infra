provider "aws" {
  region = "us-east-2"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "dynamo_policy" {
  dynamic "statement" {
    for_each = var.iam_ec2_policy_statemnts
    content {
      sid       = statement.value["sid"]
      actions   = statement.value["actions"]
      resources = statement.value["resources"]
    }
  }
}

#########################################
# IAM policy
#########################################

locals {
  iam_name_prefix = "akube-infra-ec2"
  iam_policy_name = "${local.iam_name_prefix}-policy"
  iam_alb_policy_name = "${local.iam_name_prefix}-alb-policy"
  iam_role_name   = "${local.iam_name_prefix}-role"
  iam_alb_policy_file = "files/alb_iam_policy.json"
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "v5.1.0"

  name        = local.iam_policy_name
  path        = "/"
  description = "Policy for custom K8s cluster node"

  policy = data.aws_iam_policy_document.dynamo_policy.json

  tags = {
    PolicyDescription = "Policy managed by TF for ec2 node role"
  }
}

module "iam_policy_aws_lb" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "v5.1.0"

  name        = local.iam_alb_policy_name
  path        = "/"
  description = "Policy for custom K8s cluster node"

  policy = file("${path.module}/${local.iam_alb_policy_file}")

  tags = {
    PolicyDescription = "Policy managed by TF for ec2 node: aws-load-balancer-controller from https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.2/docs/install/iam_policy.json"
  }
}


########################################
# IAM role and ec2 profile
#######################################

module "iam_assumable_role_ec2" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "v5.1.0"

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  create_role             = true
  create_instance_profile = true

  custom_role_policy_arns = [
    module.iam_policy.arn,
    module.iam_policy_aws_lb.arn
  ]
  role_name         = local.iam_role_name
  role_requires_mfa = false

  attach_admin_policy = false

  tags = {
    Role = "ec2 profile for akube infra"
  }
}

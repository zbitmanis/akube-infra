provider "aws" {
  region = local.region
}

locals {
  region    = "us-east-2"
  vpc_name  = "vpc-kube"
  sg_name   = "sgroup-kube"
  key_name  = "mc-aws"

  master_prefix = "akube-master"
  master_user_data_file = "files/init-deb-master.sh"
  worker_user_data_file = "files/init-deb-node.sh"
  worker_prefix = "akube-node"
  
  tags      = {
    "env"   = "sbox"
  }

  master_instances = {
    01 = {
      instance_type     = "t3.small"
      availability_zone = element(data.terraform_remote_state.vpc.outputs.azs, 0)
      associate_public_ip_address = true
      subnet_id         = element(data.terraform_remote_state.vpc.outputs.public_subnets, 0)
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp3"
          volume_size = 30
          tags = {
            Name = "akube-master-root-device"
          }
        }
      ]
    }
  }
  
  worker_instances = {
    01 = {
      instance_type     = "t3.small"
      availability_zone = element(data.terraform_remote_state.vpc.outputs.azs, 0)
      subnet_id         = element(data.terraform_remote_state.vpc.outputs.private_subnets, 0)
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp2"
          volume_size = 50
        }
      ]
    }
    02 = {
      instance_type     = "t3.small"
      availability_zone = element(data.terraform_remote_state.vpc.outputs.azs, 0)
      subnet_id         = element(data.terraform_remote_state.vpc.outputs.private_subnets, 0)
    }
  }
}

module "ec2_masters" {

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.0.0"

  for_each = local.master_instances

  name = "${local.master_prefix}-${each.key}"

  associate_public_ip_address = lookup(each.value, "associate_public_ip_address", false)

  ami                    = data.aws_ami.ubuntu_linux.id
  instance_type          = each.value.instance_type
  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.security_group_id]

  key_name               = local.key_name 
  iam_instance_profile   = data.terraform_remote_state.iam.outputs.iam_instance_profile_id

  enable_volume_tags = false
  root_block_device  = lookup(each.value, "root_block_device", [])

  tags = local.tags
  
  user_data_base64            = filebase64("${path.module}/${local.master_user_data_file}")
  user_data_replace_on_change = true
}

module "ec2_workers" {

  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.0.0"

  for_each = local.worker_instances

  name = "${local.master_prefix}-${each.key}"

  associate_public_ip_address = lookup(each.value, "associate_public_ip_address", false)

  ami                    = data.aws_ami.ubuntu_linux.id
  instance_type          = each.value.instance_type
  availability_zone      = each.value.availability_zone
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.security_group_id]

  key_name               = local.key_name 
  iam_instance_profile   = data.terraform_remote_state.iam.outputs.iam_instance_profile_id

  enable_volume_tags = false
  root_block_device  = lookup(each.value, "root_block_device", [])

  tags = local.tags
  
  user_data_base64            = filebase64("${path.module}/${local.worker_user_data_file}")
  user_data_replace_on_change = true
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "akube-tfstate-s3-us-east-2"
    key = "tfstate/akube/vpc.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = "akube-tfstate-s3-us-east-2"
    key = "tfstate/akube/iam.tfstate"
    region = "us-east-2"
  }
}

data "aws_ami" "ubuntu_linux" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["*ubuntu-bionic-18.04-amd64-server*"]
  }
}
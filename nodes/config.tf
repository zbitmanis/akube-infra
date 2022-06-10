terraform {
  
  backend "s3" {
    bucket = "akube-tfstate-s3-us-east-2"
    key = "tfstate/akube/nodes.tfstate"
    region = "us-east-2"
  }

  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

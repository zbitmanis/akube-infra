terraform {
  
  backend "s3" {
    bucket = "akube-tfstate-s3-us-east-2"
    key = "tfstate/akube/vpc.tfstate"
    region = "us-east-2"
  }
// TODO stick terrafrom to the particlar version across all tf's
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = local.region
}

locals {
  region = "us-east-2"
  bucket = "akube-tfstate-s3-us-east-2"
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "v3.2.3"

  bucket = local.bucket
  acl    = "private"


  versioning = {
    enabled = false
  }

}

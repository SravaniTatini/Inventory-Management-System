# Versions 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Authentication to AWS from Terraform code
provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}

terraform {
  backend "s3" {
    bucket = "ims-demobucket"
    key    = "projects_statefile/terraform.state"
    region = "ap-south-1"
  }
}












provider "aws" {
  region = "us-east-1"
}

# Local module for VPC
module "vpc" {
  source = "./modules/vpc"
}

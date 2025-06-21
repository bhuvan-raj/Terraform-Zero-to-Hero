provider "aws" {
  region = "us-east-1"
}

# Local module for VPC
module "vpc" {
  source = "./modules/vpc"
}

# Remote module for subnets (Terraform Registry)
module "subnets" {
  source  = "terraform-aws-modules/subnets/aws"
  version = "2.7.0"

  vpc_id             = module.vpc.vpc_id
  availability_zones = ["us-east-1a", "us-east-1b"]
  cidr_blocks        = ["10.0.1.0/24", "10.0.2.0/24"]
}

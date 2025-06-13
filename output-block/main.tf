provider "aws" {
  region = "us-east-1"
}

# 🔷 Create a VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.2.0.0/16"
  tags = {
    Name = "output-demo-vpc"
  }
}

# 🔷 Create a Subnet in the VPC
resource "aws_subnet" "demo_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.2.1.0/24"
  tags = {
    Name = "output-demo-subnet"
  }
}

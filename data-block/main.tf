provider "aws" {
  region = "us-east-1"
}

# 🔍 Fetch existing VPC by Name tag
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["test-vpc"]  # Update with the exact Name tag of your VPC
  }
}

# 🧱 Create a subnet inside the fetched VPC
resource "aws_subnet" "my_subnet" {
  vpc_id     = data.aws_vpc.existing.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet-in-existing-vpc"
  }
}

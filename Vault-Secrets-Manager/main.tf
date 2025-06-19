provider "vault" {
  address = "http://127.0.0.1:8200"
}

data "vault_kv_secret_v2" "aws_creds" {
  mount = "secret"
  name  = "aws-creds"
}

provider "aws" {
  region = "us-east-1"
  access_key = data.vault_kv_secret_v2.aws_creds.data["access_key"]
  secret_key = data.vault_kv_secret_v2.aws_creds.data["secret_key"]
}
resource "aws_vpc" "name" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}
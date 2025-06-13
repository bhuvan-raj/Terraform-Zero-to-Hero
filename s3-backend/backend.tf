terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"       # Replace with your actual bucket
    key            = "dev/network/terraform.tfstate"   # Path inside the bucket
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"            # Must already exist
  }
}

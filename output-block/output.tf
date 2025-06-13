# 📤 Output the VPC ID
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.demo_vpc.id
}

# 📤 Output the Subnet ID
output "subnet_id" {
  description = "The ID of the created Subnet"
  value       = aws_subnet.demo_subnet.id
}

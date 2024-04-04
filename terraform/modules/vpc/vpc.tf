# Define variables
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
}

variable "vpc_name" {
  description = "Name of the VPC"
}

variable "vpc_tags" {
  description = "Tags for the VPC"
  type        = map(string)
  default     = {}
}

# Create the VPC resource
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = var.vpc_name
    },
    var.vpc_tags
  )
}

# Output the VPC ID
output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.main_vpc.id
}
variable "vpc_id" {
  description = "ID of the VPC where the subnets should be created."
}

variable "cidr_blocks" {
  description = "List of CIDR blocks for the subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones for the subnets."
  type        = list(string)
}

variable "names" {
  description = "List of names for the subnets."
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC where the route table should be created."
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with the route table."
  type        = list(string)
}

variable "gateway_id" {
  description = "ID of the gateway (e.g., Internet Gateway) for the default route."
}

variable "name" {
  description = "Name tag for the route table."
}
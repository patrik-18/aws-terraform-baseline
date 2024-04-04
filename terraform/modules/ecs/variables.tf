variable "clusterName" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS instances"
  type        = list(string)
}

variable "ecs_instance_profile_arn" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "sg_ids" {
  description = "List of subnet IDs for ECS instances"
  type        = list(string)
}

variable "upscaling_recurrence" {
  type        = string
}

variable "downscaling_recurrence" {
  type        = string
}

variable "min_size_down" {
  type        = string
  default = 0
}

variable "desired_size_down" {
  type        = string
  default = 0
}

variable "min_size_up" {
  type        = string
  default = 0
}

variable "min_size" {
  type        = string
  default = 0
}
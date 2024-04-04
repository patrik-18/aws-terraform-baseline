variable "account_id" {
  type    = string
  default = "279806070403"
}

variable "management_account_id" {
  type    = string
  default = "515973917447"
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "environment" {
  type    = string
  default = "development"
}

# ECS variables

variable "clusterName" {
  type    = string
  default = "development-ecs-cluster"
}

variable "ecs_ami" {
  type    = string
  default = "ami-09e5466d2ec7c970d"
}

variable "key_name" {
  type    = string
  default = "development_meliovit_keypair"
}

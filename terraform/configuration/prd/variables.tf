variable "account_id" {
  type    = string
  default = "073535678493"
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
  default = "production"
}

# ECS variables

variable "clusterName" {
  type    = string
  default = "production-ecs-cluster"
}

variable "ecs_ami" {
  type    = string
  default = "ami-09e5466d2ec7c970d"
}

variable "key_name" {
  type    = string
  default = "production_meliovit_keypair"
}
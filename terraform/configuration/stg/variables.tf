variable "account_id" {
  type    = string
  default = "425849881595"
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
  default = "staging"
}

# ECS variables

variable "clusterName" {
  type    = string
  default = "staging-ecs-cluster"
}

variable "ecs_ami" {
  type    = string
  default = "ami-09e5466d2ec7c970d"
}

variable "key_name" {
  type    = string
  default = "staging_meliovit_keypair"
}
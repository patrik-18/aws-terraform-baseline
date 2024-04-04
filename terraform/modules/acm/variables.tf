variable "domain_name" {}

variable "zone_name" {
  default = ""
}

variable "subject_alternative_names" {
  type    = list(string)
  default = []
}

variable "tags" {
  type = map(string)
  default = {}
}

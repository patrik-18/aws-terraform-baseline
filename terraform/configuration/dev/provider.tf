terraform {
  required_providers {
    aws = {
      version = "5.19.0"
      source  = "hashicorp/aws"
    }
    datadog = {
      version = "3.28.0"
      source = "DataDog/datadog"
    }
  }
}
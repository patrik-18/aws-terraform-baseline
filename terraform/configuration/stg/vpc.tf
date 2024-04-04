module "my_vpc" {
  source         = "../../modules/vpc"
  vpc_cidr_block = "10.2.0.0/16"
  vpc_name       = "new-staging-vpc"
  vpc_tags       = {
    Environment = "stg"
  }
}

resource "aws_service_discovery_private_dns_namespace" "staging_service_discovery_namespace" {
  name        = "sd.staging"
  description = "Staging Service Discovery"
  vpc         = module.my_vpc.vpc_id
}
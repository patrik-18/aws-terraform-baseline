module "my_vpc" {
  source         = "../../modules/vpc"
  vpc_cidr_block = "10.3.0.0/16"
  vpc_name       = "production-vpc"
  vpc_tags       = {
    Environment = "prd"
  }
}

resource "aws_service_discovery_private_dns_namespace" "production_apps_service_discovery_namespace" {
  name        = "sd.production"
  description = "Development Service Discovery"
  vpc         = module.my_vpc.vpc_id
}
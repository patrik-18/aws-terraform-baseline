module "my_vpc" {
  source         = "../../modules/vpc"
  vpc_cidr_block = "10.1.0.0/16"
  vpc_name       = "development-vpc"
  vpc_tags       = {
    Environment = "dev"
  }
}

resource "aws_service_discovery_private_dns_namespace" "development_apps_service_discovery_namespace" {
  name        = "sd.development"
  description = "Development Service Discovery"
  vpc         = module.my_vpc.vpc_id
}

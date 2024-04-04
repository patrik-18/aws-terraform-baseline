module "acm" {
  source = "../../modules/acm"

  providers = {
    aws.management = aws.management
  }

  zone_name = "meliovit.com"

  domain_name = "${var.environment}.meliovit.com"
}

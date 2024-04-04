resource "aws_api_gateway_rest_api" "api" {
  name = "staging"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_lb" "nlb" {
  name               = "staging-nlb-stg"
  internal           = true
  load_balancer_type = "network"

  subnets = [
    module.subnets.private_subnet_1a_id,
    module.subnets.private_subnet_1b_id
  ]
}

resource "aws_api_gateway_vpc_link" "link" {
  name        = "staging-api-vpc-link"
  target_arns = [aws_lb.nlb.arn]
}

resource "aws_api_gateway_domain_name" "api" {
  regional_certificate_arn = module.acm.certificate_arn

  domain_name     = "${var.environment}.meliovit.com"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_ssm_parameter" "api_gateway_id" {
  name  = "${var.environment}-api-gateway-id"
  type  = "String"
  value = aws_api_gateway_rest_api.api.id
}

resource "aws_ssm_parameter" "api_gateway_root_resource_id" {
  name  = "${var.environment}-api-gateway-root-resource-id"
  type  = "String"
  value = aws_api_gateway_rest_api.api.root_resource_id
}

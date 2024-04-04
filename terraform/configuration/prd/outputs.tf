output "vpc_id" {
  value = module.my_vpc.vpc_id
}

output "nlb_arn" {
  value = aws_lb.nlb.arn
}

output "nlb_dns_name" {
  value = aws_lb.nlb.dns_name
}

output "aws_api_gateway_rest_api_id" {
  value = aws_api_gateway_rest_api.api.id
}

output "aws_api_gateway_rest_api_root_resource_id" {
  value = aws_api_gateway_rest_api.api.root_resource_id
}

output "aws_api_gateway_vpc_link_id" {
  value = aws_api_gateway_vpc_link.link.id
}

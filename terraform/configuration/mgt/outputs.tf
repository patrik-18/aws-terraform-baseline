output "websupport_name_servers" {
  description = "Name servers for the Websupport delegation set"
  value       = aws_route53_delegation_set.websupport.name_servers
}

output "meliovit_com_zone_id" {
  description = "ID of the Route53 zone"
  value       = module.dns_meliovit_com.zone_id
}

output "meliovit_com_arn" {
  description = "ARN of the Route53 zone"
  value       = module.dns_meliovit_com.arn
}

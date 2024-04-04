output "arn" {
  description = "ARN of the Route53 zone"
  value = aws_route53_zone.main.arn
}

output "zone_id" {
  description = "ID of the Route53 zone"
  value = aws_route53_zone.main.zone_id
}

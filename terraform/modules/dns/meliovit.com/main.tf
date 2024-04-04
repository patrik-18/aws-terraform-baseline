resource "aws_route53_zone" "main" {
  name = "meliovit.com"

  delegation_set_id = var.delegation_set_id
}

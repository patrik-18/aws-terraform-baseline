data "aws_route53_zone" "zone" {
  provider = aws.management

  name = "${local.zone_name}."
}

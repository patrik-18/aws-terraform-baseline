resource "aws_route53_delegation_set" "websupport" {
  reference_name = "Websupport"
}

module "dns_meliovit_com" {
  source = "../../modules/dns/meliovit.com"

  delegation_set_id = aws_route53_delegation_set.websupport.id
}

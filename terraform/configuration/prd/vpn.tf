resource "aws_ec2_client_vpn_endpoint" "production_vpn_endpoint" {
  description       = "production-vpn-endpoint"
  client_cidr_block = "10.11.0.0/22"
  split_tunnel = true
  dns_servers = ["8.8.8.8","8.8.4.4"]
  server_certificate_arn = "arn:aws:acm:eu-central-1:073535678493:certificate/857bbfc7-c219-42e1-b3ab-62c029c3d95f"
  vpc_id  = module.my_vpc.vpc_id
  security_group_ids = [aws_security_group.production_vpn_sg.id]
  
  authentication_options {
    type = "federated-authentication"
    saml_provider_arn = "arn:aws:iam::073535678493:saml-provider/SAML_VPN"
    self_service_saml_provider_arn = "arn:aws:iam::073535678493:saml-provider/SAML_VPN"
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.production_vpn_lg.name
  }
}

resource "aws_ec2_client_vpn_network_association" "production_vpn_nw_asc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.production_vpn_endpoint.id
  subnet_id              = aws_subnet.production_vpn_subnet_private.id
}

resource "aws_ec2_client_vpn_authorization_rule" "production_vpn_endpoint_authorization_internet" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.production_vpn_endpoint.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
}

resource "aws_cloudwatch_log_group" "production_vpn_lg" {
  name = "production-vpn-lg"
  retention_in_days = 7
}

resource "aws_subnet" "production_vpn_subnet_public" {
  vpc_id            = module.my_vpc.vpc_id
  cidr_block        = "10.3.11.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "production-vpn-subnet-public"
  }
}

resource "aws_subnet" "production_vpn_subnet_private" {
  vpc_id            = module.my_vpc.vpc_id
  cidr_block        = "10.3.12.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "production-vpn-subnet-private"
  }
}

resource "aws_route_table_association" "rtbassoc_vpn_public" {
  route_table_id = "rtb-05eb8406f45af32d5"
  subnet_id      = aws_subnet.production_vpn_subnet_public.id
}

resource "aws_route_table_association" "rtbassoc_vpn_private" {
  route_table_id = "rtb-0d3c0465f8ba95dbd"
  subnet_id      = aws_subnet.production_vpn_subnet_private.id
}

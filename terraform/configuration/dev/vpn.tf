resource "aws_ec2_client_vpn_endpoint" "development_vpn_endpoint" {
  description       = "development-vpn-endpoint"
  client_cidr_block = "10.13.0.0/22"
  split_tunnel = true
  dns_servers = ["8.8.8.8","8.8.4.4"]
  server_certificate_arn = "arn:aws:acm:eu-central-1:279806070403:certificate/c649c473-2719-4c78-b397-72fc1637f362"
  vpc_id  = module.my_vpc.vpc_id
  security_group_ids = [aws_security_group.development_vpn_sg.id]
  
  authentication_options {
    type = "federated-authentication"
    saml_provider_arn = "arn:aws:iam::279806070403:saml-provider/SSM_IDENTITY_PROVIDER"
    self_service_saml_provider_arn = "arn:aws:iam::279806070403:saml-provider/SSM_IDENTITY_PROVIDER"
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.development_vpn_lg.name
  }
}

resource "aws_ec2_client_vpn_network_association" "development_vpn_nw_asc" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.development_vpn_endpoint.id
  subnet_id              = aws_subnet.development_vpn_subnet_private.id
}

resource "aws_ec2_client_vpn_authorization_rule" "development_vpn_endpoint_authorization_internet" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.development_vpn_endpoint.id
  target_network_cidr    = "0.0.0.0/0"
  authorize_all_groups   = true
}

resource "aws_ec2_client_vpn_route" "new_stg_cidr" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.development_vpn_endpoint.id
  destination_cidr_block = "10.2.0.0/16"
  target_vpc_subnet_id   = aws_ec2_client_vpn_network_association.development_vpn_nw_asc.subnet_id
}

resource "aws_cloudwatch_log_group" "development_vpn_lg" {
  name = "development-vpn-lg"
  retention_in_days = 7
}

resource "aws_subnet" "development_vpn_subnet_public" {
  vpc_id            = module.my_vpc.vpc_id
  cidr_block        = "10.1.11.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "development-vpn-subnet-public"
  }
}

resource "aws_subnet" "development_vpn_subnet_private" {
  vpc_id            = module.my_vpc.vpc_id
  cidr_block        = "10.1.12.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "development-vpn-subnet-private"
  }
}

resource "aws_route_table_association" "rtbassoc_vpn_public" {
  route_table_id = "rtb-0efafa22bd32df07d"
  subnet_id      = aws_subnet.development_vpn_subnet_public.id
}

resource "aws_route_table_association" "rtbassoc_vpn_private" {
  route_table_id = "rtb-0cac88f2f18be8f76"
  subnet_id      = aws_subnet.development_vpn_subnet_private.id
}

module "subnets" {
  source = "../../modules/network"

  vpc_id            = module.my_vpc.vpc_id
  cidr_blocks       = [
                        "10.2.1.0/24",
                        "10.2.2.0/24",
                        "10.2.3.0/24",
                        "10.2.4.0/24",
                        "10.2.5.0/24",
                        "10.2.6.0/24",
                        "10.2.7.0/24",
                        "10.2.8.0/24"
                        ]
  availability_zones = [
                        "eu-central-1a",
                        "eu-central-1b",
                        "eu-central-1a",
                        "eu-central-1b",
                        "eu-central-1a",
                        "eu-central-1b",
                        "eu-central-1a",
                        "eu-central-1b"
                        ]
  names             = [
                        "staging-private-subnet-1a",
                        "staging-private-subnet-1b",
                        "staging-public-subnet-1a",
                        "staging-public-subnet-1b",
                        "staging-db-private-subnet-1a",
                        "staging-db-private-subnet-1b",
                        "staging-ecs-private-subnet-1a",
                        "staging-ecs-private-subnet-1b"
                        ]
}

module "route_tables_public" {
  source = "../../modules/route_tables"

  vpc_id      = module.my_vpc.vpc_id  # Use the VPC ID from your VPC module (my_vpc)
  subnet_ids  = [ module.subnets.public_subnet_1a_id,module.subnets.public_subnet_1b_id ]  # Use the subnet IDs from your subnets module
  gateway_id  = aws_internet_gateway.igw.id  # Use the Internet Gateway ID or other gateway ID
  name        = "staging-public-rtb"
}

# Private RT A

resource "aws_route_table" "staging_private_rtb_1a" {
  vpc_id      = module.my_vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id = "pcx-02882f9c0daa1f9c6"
  }

  route {
    cidr_block = "10.1.0.0/16"
    vpc_peering_connection_id = "pcx-0e6fd04faabceba21"
  }

  tags = {
    Name = "staging-private-rtb-1a"
  }
}

resource "aws_route_table_association" "staging_private_rtb_1a_pr" {
  subnet_id       = module.subnets.private_subnet_1a_id
  route_table_id  = aws_route_table.staging_private_rtb_1a.id
}

resource "aws_route_table_association" "staging_private_rtb_1a_db" {
  subnet_id       = module.subnets.private_db_subnet_1a_id
  route_table_id  = aws_route_table.staging_private_rtb_1a.id
}

resource "aws_route_table_association" "staging_private_rtb_1a_ecs" {
  subnet_id       = module.subnets.private_ecs_subnet_1a_id
  route_table_id  = aws_route_table.staging_private_rtb_1a.id
}


# Private RT B

resource "aws_route_table" "staging_private_rtb_1b" {
  vpc_id      = module.my_vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id = "pcx-02882f9c0daa1f9c6"
  }

  route {
    cidr_block = "10.1.0.0/16"
    vpc_peering_connection_id = "pcx-0e6fd04faabceba21"
  }

  tags = {
    Name = "staging-private-rtb-1b"
  }
}

resource "aws_route_table_association" "staging_private_rtb_1b_pr" {
  subnet_id       = module.subnets.private_subnet_1b_id
  route_table_id  = aws_route_table.staging_private_rtb_1b.id
}

resource "aws_route_table_association" "staging_private_rtb_1b_db" {
  subnet_id       = module.subnets.private_db_subnet_1b_id
  route_table_id  = aws_route_table.staging_private_rtb_1b.id
}

resource "aws_route_table_association" "staging_private_rtb_1b_ecs" {
  subnet_id       = module.subnets.private_ecs_subnet_1b_id
  route_table_id  = aws_route_table.staging_private_rtb_1b.id
}




resource "aws_internet_gateway" "igw" {
  vpc_id    = module.my_vpc.vpc_id

  tags = {
    Name = "staging-igw"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = module.subnets.public_subnet_1a_id

  tags = {
    Name = "staging-nat-gw"
  }
}

resource "aws_eip" "nat_eip" {
    vpc = true
}

module "subnets" {
  source = "../../modules/network"

  vpc_id            = module.my_vpc.vpc_id
  cidr_blocks       = [
                        "10.1.1.0/24",
                        "10.1.2.0/24",
                        "10.1.3.0/24",
                        "10.1.4.0/24",
                        "10.1.5.0/24",
                        "10.1.6.0/24",
                        "10.1.7.0/24",
                        "10.1.8.0/24"
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
                        "development-private-subnet-1a",
                        "development-private-subnet-1b",
                        "development-public-subnet-1a",
                        "development-public-subnet-1b",
                        "development-db-private-subnet-1a",
                        "development-db-private-subnet-1b",
                        "development-ecs-private-subnet-1a",
                        "development-ecs-private-subnet-1b"
                        ]
}

module "route_tables_public" {
  source = "../../modules/route_tables"

  vpc_id      = module.my_vpc.vpc_id  # Use the VPC ID from your VPC module (my_vpc)
  subnet_ids  = [ module.subnets.public_subnet_1a_id,module.subnets.public_subnet_1b_id ]  # Use the subnet IDs from your subnets module
  gateway_id  = aws_internet_gateway.igw.id  # Use the Internet Gateway ID or other gateway ID
  name        = "development-public-rtb"
}

# Private RT A

resource "aws_route_table" "development_private_rtb_1a" {
  vpc_id      = module.my_vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id = "pcx-001e888806a67e79a"
  }

  route {
    cidr_block = "10.2.0.0/16"
    vpc_peering_connection_id = "pcx-0e6fd04faabceba21"
  }

  tags = {
    Name = "development-private-rtb-1a"
  }
}

resource "aws_route_table_association" "development_private_rtb_1a_pr" {
  subnet_id       = module.subnets.private_subnet_1a_id
  route_table_id  = aws_route_table.development_private_rtb_1a.id
}

resource "aws_route_table_association" "development_private_rtb_1a_db" {
  subnet_id       = module.subnets.private_db_subnet_1a_id
  route_table_id  = aws_route_table.development_private_rtb_1a.id
}

resource "aws_route_table_association" "development_private_rtb_1a_ecs" {
  subnet_id       = module.subnets.private_ecs_subnet_1a_id
  route_table_id  = aws_route_table.development_private_rtb_1a.id
}


# Private RT B

resource "aws_route_table" "development_private_rtb_1b" {
  vpc_id      = module.my_vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id = "pcx-001e888806a67e79a"
  }

  route {
    cidr_block = "10.2.0.0/16"
    vpc_peering_connection_id = "pcx-0e6fd04faabceba21"
  }

  tags = {
    Name = "development-private-rtb-1b"
  }
}

resource "aws_route_table_association" "development_private_rtb_1b_pr" {
  subnet_id       = module.subnets.private_subnet_1b_id
  route_table_id  = aws_route_table.development_private_rtb_1b.id
}

resource "aws_route_table_association" "development_private_rtb_1b_db" {
  subnet_id       = module.subnets.private_db_subnet_1b_id
  route_table_id  = aws_route_table.development_private_rtb_1b.id
}

resource "aws_route_table_association" "development_private_rtb_1b_ecs" {
  subnet_id       = module.subnets.private_ecs_subnet_1b_id
  route_table_id  = aws_route_table.development_private_rtb_1b.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id    = module.my_vpc.vpc_id

  tags = {
    Name = "development-igw"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = module.subnets.public_subnet_1a_id

  tags = {
    Name = "development-nat-gw"
  }
}

resource "aws_eip" "nat_eip" {
    vpc = true
}

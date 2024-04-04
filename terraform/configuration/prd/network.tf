module "subnets" {
  source = "../../modules/network"

  vpc_id            = module.my_vpc.vpc_id
  cidr_blocks       = [
                        "10.3.1.0/24",
                        "10.3.2.0/24",
                        "10.3.3.0/24",
                        "10.3.4.0/24",
                        "10.3.5.0/24",
                        "10.3.6.0/24",
                        "10.3.7.0/24",
                        "10.3.8.0/24"
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
                        "production-private-subnet-1a",
                        "production-private-subnet-1b",
                        "production-public-subnet-1a",
                        "production-public-subnet-1b",
                        "production-db-private-subnet-1a",
                        "production-db-private-subnet-1b",
                        "production-ecs-private-subnet-1a",
                        "production-ecs-private-subnet-1b"
                        ]
}

module "route_tables_private_1a" {
  source = "../../modules/route_tables"

  vpc_id      = module.my_vpc.vpc_id  # Use the VPC ID from your VPC module (my_vpc)
  subnet_ids  = [ 
                  module.subnets.private_subnet_1a_id,
                  module.subnets.private_db_subnet_1a_id,
                  module.subnets.private_ecs_subnet_1a_id
                ]  # Use the subnet IDs from your subnets module
  gateway_id  = aws_nat_gateway.nat_gw.id  # Use the Internet Gateway ID or other gateway ID
  name        = "production-private-rtb-1a"
}

module "route_tables_private_1b" {
  source = "../../modules/route_tables"

  vpc_id      = module.my_vpc.vpc_id  # Use the VPC ID from your VPC module (my_vpc)
  subnet_ids  = [ 
                  module.subnets.private_subnet_1b_id,
                  module.subnets.private_db_subnet_1b_id,
                  module.subnets.private_ecs_subnet_1b_id
                ]  # Use the subnet IDs from your subnets module
  gateway_id  = aws_nat_gateway.nat_gw.id  # Use the Internet Gateway ID or other gateway ID
  name        = "production-private-rtb-1b"
}

module "route_tables_public" {
  source = "../../modules/route_tables"

  vpc_id      = module.my_vpc.vpc_id  # Use the VPC ID from your VPC module (my_vpc)
  subnet_ids  = [
                  module.subnets.public_subnet_1a_id,
                  module.subnets.public_subnet_1b_id
                ]  # Use the subnet IDs from your subnets module
  gateway_id  = aws_internet_gateway.igw.id  # Use the Internet Gateway ID or other gateway ID
  name        = "production-public-rtb"
}

resource "aws_internet_gateway" "igw" {
  vpc_id    = module.my_vpc.vpc_id

  tags = {
    Name = "production-igw"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = module.subnets.public_subnet_1a_id

  tags = {
    Name = "production-nat-gw"
  }
}

resource "aws_eip" "nat_eip" {
    vpc = true
}

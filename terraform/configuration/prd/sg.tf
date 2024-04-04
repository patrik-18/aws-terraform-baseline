resource "aws_security_group" "ecs_ec2_sg" {
  name        = "production-ecs-ec2-sg"
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
  vpc_id      = module.my_vpc.vpc_id

    ingress {
        from_port       = -1
        to_port         = -1
        protocol        = "icmp"
        cidr_blocks     = ["10.3.0.0/16"]
    }
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["10.3.0.0/16"]
    }
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["10.3.0.0/16"]
    }
    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["10.3.0.0/16"]
    }
    ingress {
        from_port       = 8080
        to_port         = 9010
        protocol        = "tcp"
        cidr_blocks     = ["10.3.0.0/16"]
    }
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ecs_sg" {
  name        = "production-ecs-sg"
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
  vpc_id      = module.my_vpc.vpc_id

  ingress {
        from_port       = -1
        to_port         = -1
        protocol        = "icmp"
        cidr_blocks     = ["10.3.0.0/16"]
  }
  ingress {
      description      = "HTTP from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
      description      = "HTTPS from VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
        from_port       = 8080
        to_port         = 9010
        protocol        = "tcp"
        cidr_blocks     = ["10.3.0.0/16"]
    }
  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "production_db_security_group" {
  vpc_id      = module.my_vpc.vpc_id
  name        = "production-db-security-group"
  description = "Allow VPC inbound for Postgres"
    ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.3.0.0/16"]
  }
}

resource "aws_security_group" "production_vpn_sg" {
  vpc_id      = module.my_vpc.vpc_id
  name        = "production-vpn-sg"

  ingress {
    from_port = 443
    protocol = "UDP"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "Incoming VPN connection"
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
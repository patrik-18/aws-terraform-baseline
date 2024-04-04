resource "aws_security_group" "ecs_ec2_sg" {
  name        = "ecs_ec2_sg"
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
  vpc_id      = module.my_vpc.vpc_id

    ingress {
        from_port       = -1
        to_port         = -1
        protocol        = "icmp"
        cidr_blocks     = ["10.2.0.0/16"]
    }
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["10.2.0.0/16"]
    }
    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["10.2.0.0/16"]
    }
    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["10.2.0.0/16"]
    }
    ingress {
        from_port       = 8080
        to_port         = 9010
        protocol        = "tcp"
        cidr_blocks     = ["10.2.0.0/16"]
    }
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ecs_alb_sg" {
  name        = "ecs_alb_sg"
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
  vpc_id      = module.my_vpc.vpc_id

  ingress {
        from_port       = -1
        to_port         = -1
        protocol        = "icmp"
        cidr_blocks     = ["10.2.0.0/16"]
  }
  ingress {
      description      = "TLS from VPC"
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
        cidr_blocks     = ["10.2.0.0/16"]
    }
  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "staging_db_security_group" {
  vpc_id      = module.my_vpc.vpc_id
  name        = "staging-db-security-group"
  description = "Allow VPC inbound for Postgres"
ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/22"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.13.0.0/22"]
  }
}
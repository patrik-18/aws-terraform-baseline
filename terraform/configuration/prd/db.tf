# production PostgreSQL Cluster
data "aws_secretsmanager_secret" "production_aurora_secret" {
  name = "production-aurora-password"
}

data "aws_secretsmanager_secret_version" "production_aurora_secret_version_v2" {
  secret_id = data.aws_secretsmanager_secret.production_aurora_secret.id
}

resource "aws_rds_cluster" "production_aurora_cluster" {
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
  engine_version          = "15.3"
  cluster_identifier      = "aurora-cluster"
  master_username         = "dbadmin"
  master_password         = data.aws_secretsmanager_secret_version.production_aurora_secret_version_v2.secret_string
  
  db_subnet_group_name    = aws_db_subnet_group.production_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.production_db_security_group.id]
  
  backup_retention_period = 7
  skip_final_snapshot     = true

  storage_encrypted = true
  kms_key_id = "arn:aws:kms:eu-central-1:073535678493:key/77f3b404-add0-40e0-a609-6508a08d6d90"

}

resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier         = "${"aurora-cluster-instance"}-${count.index}"
  count              = 1
  cluster_identifier = aws_rds_cluster.production_aurora_cluster.id
  instance_class     = "db.t4g.medium"
  engine             = aws_rds_cluster.production_aurora_cluster.engine
  engine_version     = aws_rds_cluster.production_aurora_cluster.engine_version
  
  publicly_accessible = false
}


# Network settings

resource "aws_db_subnet_group" "production_db_subnet_group" {
  name       = "production-db-subnet-group"
  subnet_ids = [module.subnets.private_db_subnet_1a_id,module.subnets.private_db_subnet_1b_id]
  tags = {
    Name = "production-db-subnet-group"
  }
}
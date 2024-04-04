resource "aws_kms_key" "meliovit_production_kms_db" {
  description             = "KMS key used to DB encryption"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "meliovit_production_kms_db" {
  name          = "alias/meliovit_production_kms_db"
  target_key_id = aws_kms_key.meliovit_production_kms_db.key_id
}

resource "aws_kms_key" "meliovit_production_kms" {
  description             = "KMS key used to DB encryption"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "meliovit_production_kms" {
  name          = "alias/meliovit_production_kms"
  target_key_id = aws_kms_key.meliovit_production_kms.key_id
}
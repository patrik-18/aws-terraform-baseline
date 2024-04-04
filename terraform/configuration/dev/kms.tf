resource "aws_kms_key" "meliovit_development_kms_db" {
  description             = "KMS key used to DB encryption"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "meliovit_development_kms_db" {
  name          = "alias/meliovit_development_kms_db"
  target_key_id = aws_kms_key.meliovit_development_kms_db.key_id
}

resource "aws_kms_key" "meliovit_development_kms" {
  description             = "KMS key used to DB encryption"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "meliovit_development_kms" {
  name          = "alias/meliovit_development_kms"
  target_key_id = aws_kms_key.meliovit_development_kms.key_id
}
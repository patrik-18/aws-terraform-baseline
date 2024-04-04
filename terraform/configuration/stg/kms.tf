resource "aws_kms_key" "meliovit_staging_kms_db" {
  description             = "KMS key used to DB encryption"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "meliovit_staging_kms_db" {
  name          = "alias/meliovit_staging_kms_db_stg"
  target_key_id = aws_kms_key.meliovit_staging_kms_db.key_id
}

resource "aws_kms_key" "meliovit_staging_kms" {
  description             = "KMS key used to DB encryption"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "meliovit_staging_kms" {
  name          = "alias/meliovit_staging_kms_stg"
  target_key_id = aws_kms_key.meliovit_staging_kms.key_id
}
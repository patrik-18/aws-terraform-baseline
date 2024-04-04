provider "aws" {

  default_tags {
    tags = local.provider_tags
  }

  region              = "eu-central-1"
  allowed_account_ids = [var.account_id]

  assume_role {
    role_arn      = local.tfm_deploy_role_arn
  }
}

provider "aws" {
  alias = "management"

  default_tags {
    tags = local.provider_tags
  }

  region              = "eu-central-1"
  allowed_account_ids = [var.management_account_id]

  assume_role {
    role_arn      = local.tfm_management_role_arn
  }
}
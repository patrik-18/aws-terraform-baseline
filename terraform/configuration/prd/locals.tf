locals {
  tfm_deploy_role_name = "production-cicd-automation"
  tfm_deploy_role_arn  = "arn:aws:iam::${var.account_id}:role/${local.tfm_deploy_role_name}"

  tfm_management_role_name = "management-cicd-automation"
  tfm_management_role_arn  = "arn:aws:iam::${var.management_account_id}:role/${local.tfm_management_role_name}"

  iac_repo           = "https://github.com/Meliovit/aws-terraform-baseline"
  service_group_name = "infrastructure"
  environment        = var.environment

  provider_tags = {
    IacRepo      = local.iac_repo
    ServiceGroup = local.service_group_name
    Environment  = local.environment
  }
}
terraform {
  backend "s3" {
    bucket  = "tfm-state-279806070403"
    region  = "eu-central-1"
    encrypt = "true"
    dynamodb_table = "github-state-lock"
    #####################################################
    ### IMPORTANT - MUST BE CHANGED FOR EVERY USECASE ###
    #####################################################
    #key =  # SPECIFIED AS INIT INPUT VARIABLE
  }
}
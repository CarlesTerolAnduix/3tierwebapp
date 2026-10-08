provider "aws" {
  region = "us-east-1"
}

module "stage" {
  source      = "../modules"
  env         = "stage"
  db_password = var.db_password
}

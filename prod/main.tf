provider "aws" {
  region = "us-east-2"
}

module "prod" {
  source      = "../modules"
  env         = "prod"
  db_password = var.db_password
}

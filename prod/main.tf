provider "aws" {
  region = "us-east-2"
}

module "prod" {
  source                  = "../modules"
  env                     = "prod"
  db_password             = var.db_password
  multi_az                = true
  deletion_protection     = true
  backup_retention_period = 7
}

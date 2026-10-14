provider "aws" {
  region = "us-east-2"
}

module "prod" {
  source                  = "../modules"
  env                     = "prod"
  multi_az                = true
  deletion_protection     = true
  backup_retention_period = 7
}

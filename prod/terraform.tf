terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket       = "cursor-backend-5236"
    key          = "3tier-webapp/prod/terraform.tfstate"
    region       = "us-east-1" # Same bucket for prod and stage.
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

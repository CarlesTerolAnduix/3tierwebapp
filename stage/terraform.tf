terraform {
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket       = "cursor-backend-5236"
    key          = "3tier-webapp/stage/terraform.tfstate"
    region       = "us-east-1"
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

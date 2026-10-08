provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "cursor_backend" {
  bucket = "cursor-backend-5236"
}

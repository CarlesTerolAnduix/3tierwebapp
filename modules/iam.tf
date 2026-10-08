# IAM

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_role" "ec2_rds_role" {
  name = "ec2-rds-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "ec2_rds_connect" {
  name = "rds-iam-connect-${var.env}"
  role = aws_iam_role.ec2_rds_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "rds-db:connect"
      Resource = "arn:aws:rds-db:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_db_instance.webserver_db.resource_id}/webapp"
    }]
  })
}

resource "aws_iam_instance_profile" "webserver" {
  name = "ec2-rds-${var.env}"
  role = aws_iam_role.ec2_rds_role.name
}

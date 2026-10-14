# SECURITY

locals {
  http_port   = 80
  db_port     = 3306
  db_iam_user = "webapp"
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-${var.env}"
  description = "Allow HTTP traffic to the ALB"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "alb-sg-${var.env}"
  }
}

resource "aws_security_group" "webserver_sg" {
  name        = "webserver-sg-${var.env}"
  description = "Allow HTTP traffic from ALB and MySQL traffic to RDS"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "webserver-sg-${var.env}"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-${var.env}"
  description = "Allow MySQL traffic from EC2"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "rds-sg-${var.env}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_ec2_rule" {
  security_group_id            = aws_security_group.webserver_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = local.http_port
  to_port                      = local.http_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_alb_rule" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = local.http_port
  to_port           = local.http_port
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress_alb_rule" {
  security_group_id            = aws_security_group.alb_sg.id
  referenced_security_group_id = aws_security_group.webserver_sg.id
  from_port                    = local.http_port
  to_port                      = local.http_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rds_rule" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.webserver_sg.id
  from_port                    = local.db_port
  to_port                      = local.db_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress_ec2_rule" {
  security_group_id            = aws_security_group.webserver_sg.id
  referenced_security_group_id = aws_security_group.rds_sg.id
  from_port                    = local.db_port
  to_port                      = local.db_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress_ec2_http" {
  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = local.http_port
  to_port           = local.http_port
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "egress_ec2_https" {
  security_group_id = aws_security_group.webserver_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

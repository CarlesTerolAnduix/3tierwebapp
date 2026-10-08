# COMPUTE RESOURCES

# Example of instance
# resource "aws_instance" "webserver" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   subnet_id     = aws_subnet.ec2_a.id
#
#   tags = {
#     Name = "Webserver-${var.env}"
#   }
# }

resource "aws_launch_template" "webserver" {
  name_prefix            = "webserver-${var.env}-"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]

  user_data = base64encode(templatefile("${path.module}/user_data.sh.tftpl", {
    db_host     = aws_db_instance.webserver_db.address
    db_port     = local.db_port
    db_name     = aws_db_instance.webserver_db.db_name
    db_user     = aws_db_instance.webserver_db.username
    db_password = var.db_password
  }))

  iam_instance_profile {
    name = aws_iam_instance_profile.webserver.name
  }

  # tag_specifications {
  #   resource_type = "instance"
  #   tags = {
  #     Name = "Webserver-${var.env}"
  #   }
  # }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_autoscaling_group" "webserver_asg" {
  desired_capacity    = 2
  max_size            = 5
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.ec2_a.id, aws_subnet.ec2_b.id]
  target_group_arns   = [aws_lb_target_group.webserver_tg.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.webserver.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Webserver-${var.env}"
    propagate_at_launch = true
  }
}

resource "aws_alb" "webserver_alb" {
  name               = "webserver-alb-${var.env}"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  security_groups    = [aws_security_group.alb_sg.id]

  depends_on = [
    aws_route_table_association.public_a,
    aws_route_table_association.public_b,
  ]

  tags = {
    Name = "webserver-alb-${var.env}"
  }
}

resource "aws_lb_target_group" "webserver_tg" {
  name     = "webserver-tg-${var.env}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "webserver_listener" {
  load_balancer_arn = aws_alb.webserver_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_tg.arn
  }
}

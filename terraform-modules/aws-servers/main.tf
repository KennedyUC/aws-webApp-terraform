resource "aws_launch_configuration" "WebAppLaunchConfig" {
  name                 = "WebAppLaunchConfig"
  image_id             = var.ec2_ami_id
  instance_type        = var.ec2_instance_type
  security_groups      = [var.security_group_id]
  user_data            = base64encode(
    <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install unzip -y
    apt-get install apache2 -y
    cd /var/www/html
    wget https://raw.githubusercontent.com/KennedyUC/cloudDevops-IaC/main/udagram-web.zip
    unzip -o udagram-web.zip
    rm udagram-web.zip
    systemctl enable apache2.service
    systemctl start apache2.service
    EOF
  )

  ebs_block_device {
    device_name = "/dev/sdk"
    volume_type = "standard"
    volume_size = 10
  }
}

resource "aws_lb_target_group" "WebAppTargetGroup" {
  name     = "WebAppTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 10
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 8
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  depends_on = [aws_launch_configuration.WebAppLaunchConfig]
}

resource "aws_autoscaling_group" "WebAppGroup" {
  name                 = "WebAppGroup"
  vpc_zone_identifier  = var.private_subnet_ids
  launch_configuration = aws_launch_configuration.WebAppLaunchConfig.name
  min_size             = var.min_instance_count
  max_size             = var.max_instance_count
  target_group_arns    = [aws_lb_target_group.WebAppTargetGroup.arn]

  depends_on = [aws_lb_target_group.WebAppTargetGroup]
}

resource "aws_lb" "WebAppLB" {
  name               = "WebAppLB"
  subnets            = var.public_subnet_ids
  security_groups    = [var.security_group_id]

  depends_on = [aws_autoscaling_group.WebAppGroup]
}

resource "aws_lb_listener" "Listener" {
  load_balancer_arn = aws_lb.WebAppLB.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WebAppTargetGroup.arn
  }

  depends_on = [aws_lb.WebAppLB]
}

resource "aws_lb_listener_rule" "ALBListenerRule" {
  listener_arn = aws_lb_listener.Listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WebAppTargetGroup.arn
  }

  condition {
    path_pattern {
    values = ["/"]
    }
  }

  depends_on = [aws_lb_listener.Listener]
}
resource "aws_security_group" "lb_sg" {
  name        = "depl-lb-sg"
  description = "Security group for Deployment Server Load Balancer"
  vpc_id      = aws_vpc.kts_vpc.id

  tags = {
    project_name = local.project_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4_lb" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4_lb" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_lb" {
  security_group_id = aws_security_group.lb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_subnet" "lb_subnet_1" {
  vpc_id            = aws_vpc.kts_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = var.az

  tags = {
    Name         = "lb-subnet-1"
    project_name = local.project_name
  }
}

resource "aws_subnet" "lb_subnet_2" {
  vpc_id            = aws_vpc.kts_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = var.az1

  tags = {
    Name         = "lb-subnet-2"
    project_name = local.project_name
  }
}

resource "aws_route_table_association" "lb_subnet_1_assoc" {
  subnet_id      = aws_subnet.lb_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "lb_subnet_2_assoc" {
  subnet_id      = aws_subnet.lb_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_lb" "depl_lb" {
  name               = "depl-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.lb_subnet_1.id, aws_subnet.lb_subnet_2.id]

  tags = {
    project_name = local.project_name
  }
}

resource "aws_lb_target_group" "admin_tg" {
  name     = "depl-tg-5173"
  port     = 5173
  protocol = "HTTP"
  vpc_id   = aws_vpc.kts_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = {
    project_name = local.project_name
  }
}

resource "aws_lb_target_group" "user_tg" {
  name     = "depl-tg-5174"
  port     = 5174
  protocol = "HTTP"
  vpc_id   = aws_vpc.kts_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = {
    project_name = local.project_name
  }
}

resource "aws_lb_target_group" "backend_tg" {
  name     = "depl-tg-4000"
  port     = 4000
  protocol = "HTTP"
  vpc_id   = aws_vpc.kts_vpc.id

  health_check {
    path                = "/api/health" # Assuming a health check endpoint exists, or "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = {
    project_name = local.project_name
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.depl_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "front_end_https" {
  load_balancer_arn = aws_lb.depl_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.kts_cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: Not Found"
      status_code  = "404"
    }
  }
}





resource "aws_lb_listener_rule" "admin_rule" {
  listener_arn = aws_lb_listener.front_end_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.admin_tg.arn
  }

  condition {
    host_header {
      values = ["kts-admin.kavindu-gihan.tech"]
    }
  }
}

resource "aws_lb_listener_rule" "user_rule" {
  listener_arn = aws_lb_listener.front_end_https.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user_tg.arn
  }

  condition {
    host_header {
      values = ["kts-user.kavindu-gihan.tech"]
    }
  }
}

resource "aws_lb_listener_rule" "backend_rule" {
  listener_arn = aws_lb_listener.front_end_https.arn
  priority     = 102

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_tg.arn
  }

  condition {
    host_header {
      values = ["kts-backend.kavindu-gihan.tech"]
    }
  }
}

resource "aws_lb_target_group_attachment" "admin_attach" {
  target_group_arn = aws_lb_target_group.admin_tg.arn
  target_id        = aws_instance.depl.id
  port             = 5173
}

resource "aws_lb_target_group_attachment" "user_attach" {
  target_group_arn = aws_lb_target_group.user_tg.arn
  target_id        = aws_instance.depl.id
  port             = 5174
}

resource "aws_lb_target_group_attachment" "backend_attach" {
  target_group_arn = aws_lb_target_group.backend_tg.arn
  target_id        = aws_instance.depl.id
  port             = 4000
}




// Target Group ALB
resource "aws_lb_target_group" "target" {
  name                 = "http-tg"
  deregistration_delay = "30"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = aws_vpc.vpc.id
}

// Listerner

resource "aws_lb_listener" "lab_http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
}
/*
resource "aws_lb_listener" "lab_https" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = local.certificate_arn
  ssl_policy        = local.ssl_policy
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
}
*/
// ALB

resource "aws_lb" "lb" {
  name_prefix                = "lab-"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg_lb.id]
  subnets                    = aws_subnet.public.*.id
  enable_deletion_protection = true

  tags = {
    env = "live"
  }
}


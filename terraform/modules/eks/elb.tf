# Application Load Balancer
resource "aws_lb" "eks_alb" {
  name               = "${var.alb_name}"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.alb_sg_id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.alb_name}"
  }
}

# ALB listener for HTTPS with OIDC authentication
resource "aws_lb_listener" "alb_443" {
  load_balancer_arn = aws_lb.eks_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.certificate_arn
  default_action {
    type = "authenticate-oidc"
    authenticate_oidc {
      authorization_endpoint     = var.authorization_url
      token_endpoint             = var.token_url
      client_id                  = var.client_id
      client_secret              = var.client_secret
      issuer                     = var.oauth2_issuer_url
      user_info_endpoint         = var.user_info_endpoint
      session_cookie_name        = "AWSELBAuthSessionCookie"
      session_timeout            = "300"
      scope                      = "openid email profile"
      on_unauthenticated_request = "authenticate"
    }
  }
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks.arn
  }
}

# Target Group for ALB
resource "aws_lb_target_group" "eks" {
  name        = "eks-tg"
  port        = 30102
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 300
    path                = "/"
    matcher             = "200-299"
  }

  tags = {
    Name = "${aws_lb.eks_alb.name}-tg"
  }
}

# Attach EKS Node Group ASG to ALB Target Group
resource "aws_autoscaling_attachment" "eks_tg_attachment" {
  autoscaling_group_name = aws_eks_node_group.eks_node_group.resources[0].autoscaling_groups[0].name
  lb_target_group_arn    = aws_lb_target_group.eks.arn
}

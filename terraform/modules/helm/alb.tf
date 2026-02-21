# TODO: Move this shit to a separate module and add argocd LB, static NodePort values.

# Application Load Balancer
resource "aws_lb" "argocd_alb" {
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

# ALB listener for HTTPS 
resource "aws_lb_listener" "alb_443" {
  load_balancer_arn = aws_lb.argocd_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.argocd.arn
  }
}

# Target Group for ALB
resource "aws_lb_target_group" "argocd" {
  name        = "argocd-tg"
  port        = 30080
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
    Name = "${aws_lb.argocd_alb.name}-tg"
  }
}

# Attach ArgoCD Node Group ASG to ALB Target Group
resource "aws_autoscaling_attachment" "argocd_tg_attachment" {
  autoscaling_group_name = var.autoscaling_group_name
  lb_target_group_arn    = aws_lb_target_group.argocd.arn
}

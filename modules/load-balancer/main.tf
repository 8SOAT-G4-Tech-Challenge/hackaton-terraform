# Criação do Target Group do Application Load Balancer
resource "aws_lb_target_group" "aws_alb_tg" {
  name        = "${var.environment}-${var.project_name}-alb-tg"
  port        = 31333
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    path                = "/files/health"
    port                = 31333
    matcher             = "200"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# Criação do Application Load Balancer
resource "aws_lb" "alb" {
  name               = "${var.environment}-${var.project_name}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.private_subnet_ids

  tags = {
    Environment = var.environment
  }
}

# Criação do Listener para o Application Load Balancer
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_alb_tg.arn
  }
}

# Redirecionar rotas /files ao target group correto
resource "aws_lb_listener_rule" "file_rule" {
  listener_arn = aws_lb_listener.alb_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_alb_tg.arn
  }

  condition {
    path_pattern {
      values = ["/files/*"]
    }
  }
}

# Conectar target group ao node correto
resource "aws_lb_target_group_attachment" "files_tg_attachment" {
  target_group_arn = aws_lb_target_group.aws_alb_tg.arn
  target_id        = data.aws_instance.ec2.id
  port             = 31333
}

# Target Groups #

resource "aws_lb_target_group" "frontend" {
  name        = "${var.project}-${var.environment}-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    timeout             = 5
    path                = "/" #Konfig tlyko do testow
    #path                = "/healthz" #Docelowy konfig
    protocol            = "HTTP"
    matcher             = "200-399" #Konfig tlyko do testow
    #matcher             = "200" #Docelowy konfig
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = merge(
    {
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_lb_target_group" "backend" {
  name        = "${var.project}-${var.environment}-backend-tg"
  port        = 8000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

    health_check {
    enabled             = true
    interval            = 30
    timeout             = 5
    path                = "/" #Konfig tlyko do testow
    #path                = "/healthz" #Docelowy konfig
    protocol            = "HTTP"
    matcher             = "200-399" #Konfig tlyko do testow
    #matcher             = "200" #Docelowy konfig
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }


  # health_check {
  #   enabled             = true
  #   interval            = 30
  #   timeout             = 5
  #   path                = "/health"
  #   protocol            = "HTTP"
  #   matcher             = "200-399" //Bo redirecty w pythonie 
  #   healthy_threshold   = 3
  #   unhealthy_threshold = 3
  # }

  tags = merge(
    {
      Environment = var.environment
    },
    var.tags,
  )
}

# ALB #
resource "aws_lb" "this" {
  name        = "${var.project}-${var.environment}-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [var.alb_sg_id]
  subnets         = var.public_subnet_ids

  tags = merge(
    {
      Environment = var.environment
    },
    var.tags,
  )
}


# Listeners#

#ZAKOMENTOWANE BO TESTUJE BEZ DNS
# Listener HTTP: 80 -> redirect HTTPS 443
# resource "aws_lb_listener" "http_redirect" {
#   load_balancer_arn = aws_lb.this.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# # Listener HTTPS: 443 -> frontend TG
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.this.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.acm_certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.frontend.arn
#   }
# }

# Listener HTTP: 80 -> frontend TG
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}
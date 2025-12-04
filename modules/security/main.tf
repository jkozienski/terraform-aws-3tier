# Security groups #

#WEB
resource "aws_security_group" "todolist_web" {
  name        = "todolist-web-security-group"
  description = "Security group for todolist web EC2"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name        = "todolist-web-security-group"
      Environment = var.environment
    },
    var.tags,
  )
}


# resource "aws_vpc_security_group_ingress_rule" "todolist_web_http_test" {
#   security_group_id = aws_security_group.todolist_web.id
#   cidr_ipv4         = "0.0.0.0/0"

#   ip_protocol = "tcp"
#   from_port   = 80
#   to_port     = 80
# }

resource "aws_vpc_security_group_ingress_rule" "todolist_web_from_alb" {
  security_group_id            = aws_security_group.todolist_web.id
  referenced_security_group_id = aws_security_group.alb.id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

}

resource "aws_vpc_security_group_ingress_rule" "todolist_web_ssh" {
  for_each = toset(var.ssh_cidr_blocks)
  security_group_id = aws_security_group.todolist_web.id
  cidr_ipv4         = each.key

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "todolist_web_all" {
  security_group_id = aws_security_group.todolist_web.id
  cidr_ipv4         = "0.0.0.0/0"

  ip_protocol = "-1"
}



#APP
resource "aws_security_group" "todolist_app" {
  name        = "todolist-app-security-group"
  description = "Security group for todolist app EC2"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name        = "todolist-app-security-group"
      Environment = var.environment
    },
    var.tags,
  )
}

resource "aws_vpc_security_group_ingress_rule" "todolist_app_from_web" {
  security_group_id            = aws_security_group.todolist_app.id
  referenced_security_group_id = aws_security_group.todolist_web.id

  ip_protocol = "tcp"
  from_port   = 8000
  to_port     = 8000
}

/*Chyba niepotrzebne
resource "aws_vpc_security_group_ingress_rule" "todolist_app_admin" {
  for_each = toset(var.ssh_cidr_blocks)
  # var.ssh_cidr_blocks ma np. ["157.158.136.112/32", "185.25.121.234/32"]

  security_group_id = aws_security_group.todolist_app.id
  cidr_ipv4         = each.key

  ip_protocol = "tcp"
  from_port   = 8000
  to_port     = 8000
}
*/
resource "aws_vpc_security_group_ingress_rule" "todolist_app_ssh_from_web" {
  security_group_id            = aws_security_group.todolist_app.id
  referenced_security_group_id = aws_security_group.todolist_web.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "todolist_app_from_alb" {
  security_group_id            = aws_security_group.todolist_app.id
  referenced_security_group_id = aws_security_group.alb.id

  ip_protocol = "tcp"
  from_port   = 8000
  to_port     = 8000
}


resource "aws_vpc_security_group_egress_rule" "todolist_app_all" {
  security_group_id = aws_security_group.todolist_app.id
  cidr_ipv4         = "0.0.0.0/0"

  ip_protocol = "-1"
}




#DB
resource "aws_security_group" "todolist_db" {
    name        = "todolist-database-security-group"
    description = "Security group for todolist database"
    vpc_id      = var.vpc_id
    
    tags = merge(
        {
        Name        = "todolist-database-security-group"
        Environment = var.environment
        },
        var.tags,
    )
}

resource "aws_vpc_security_group_ingress_rule" "todolist_db_from_app" {
  security_group_id            = aws_security_group.todolist_db.id
  referenced_security_group_id = aws_security_group.todolist_app.id

  ip_protocol = "tcp"
  from_port   = 5432
  to_port     = 5432
}

resource "aws_vpc_security_group_ingress_rule" "todolist_db_ssh_from_web" {
  security_group_id            = aws_security_group.todolist_db.id
  referenced_security_group_id = aws_security_group.todolist_web.id

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "todolist_db_all" {
  security_group_id = aws_security_group.todolist_db.id
  cidr_ipv4         = "0.0.0.0/0"

  ip_protocol = "-1"
}


# ALB #
resource "aws_security_group" "alb" {
  name        = "alb-security-group"
  description = "Security group for todolist load balancer"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name        = "todolist-alb-security-group"
      Environment = var.environment
    },
    var.tags,
  )
}

# HTTP
resource "aws_vpc_security_group_ingress_rule" "alb_http_from_internet" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# HTTPS
resource "aws_vpc_security_group_ingress_rule" "alb_https_from_internet" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


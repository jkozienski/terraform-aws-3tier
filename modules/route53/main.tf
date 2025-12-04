resource "aws_route53_zone" "this" {
  name = var.domain_name

  tags = merge(
    {
      Name = var.domain_name
    },
    var.tags,
  )
}

# kozkowsky.space -> ALB
resource "aws_route53_record" "root_domain" {
  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# www.kozkowsky.space -> ALB
resource "aws_route53_record" "www_domain" {
  zone_id = aws_route53_zone.this.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

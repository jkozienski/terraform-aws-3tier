resource "aws_route53_zone" "this" {
  name = var.domain_name

  tags = merge(
    {
      Name = var.domain_name
    },
    var.tags,
  )
}

# DNS domain -> ALB
resource "aws_route53_record" "root_domain" {
  count = var.create_alias_records ? 1 : 0

  zone_id = aws_route53_zone.this.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

#  DNS domain with www -> ALB
resource "aws_route53_record" "www_domain" {
  count = var.create_alias_records ? 1 : 0

  zone_id = aws_route53_zone.this.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

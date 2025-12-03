resource "aws_route53_zone" "this" {
  name = var.domain_name

  tags = merge(
    {
      Name = var.domain_name
    },
    var.tags,
  )
}

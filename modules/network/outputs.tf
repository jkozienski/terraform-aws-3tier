output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "alb_subnet_ids" {
  value = aws_subnet.alb_public[*].id
}

output "frontend_subnet_ids" {
  value = aws_subnet.frontend[*].id
}

output "backend_subnet_ids" {
  value = aws_subnet.backend[*].id
}

output "db_subnet_ids" {
  value = aws_subnet.db[*].id
}

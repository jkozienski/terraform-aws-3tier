output "web_sg_id" {
  description = "ID security group for todolist web EC2"
  value       = aws_security_group.todolist_web.id
}

output "app_sg_id" {
  description = "ID security group for todolist app EC2"
  value       = aws_security_group.todolist_app.id
}

output "db_sg_id" {
  description = "ID security group for todolist DB EC2"
  value       = aws_security_group.todolist_db.id
}


output "alb_sg_id" {
  description = "ID security group for todolist ALB EC2"
  value       = aws_security_group.alb.id
}
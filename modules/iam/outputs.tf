
output "instance_profile_arn" {
  value = aws_iam_instance_profile.ec2_profile.arn
}

output "role_name" {
  value = aws_iam_role.ec2_role.name
}
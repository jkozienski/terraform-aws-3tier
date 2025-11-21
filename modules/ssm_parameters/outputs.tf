output "string_parameter_names" {
  value       = [for p in aws_ssm_parameter.string : p.name]
}

output "secure_parameter_names" {
  value       = [for p in aws_ssm_parameter.secure : p.name]
}

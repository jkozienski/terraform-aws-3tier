# String parameters
resource "aws_ssm_parameter" "string" {
  for_each = var.string_parameters

  name  = "${var.parameter_path_prefix}/${each.key}"
  type  = "String"
  value = each.value
}

# SecureString parameters
resource "aws_ssm_parameter" "secure" {
  for_each = var.securestring_parameters

  name  = "${var.parameter_path_prefix}/${each.key}"
  type  = "SecureString"
  value = each.value
}


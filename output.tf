output "private_ssm" {
  value = aws_ssm_parameter.private_key.name
}

output "public_ssm" {
  value = aws_ssm_parameter.public_key.name
}
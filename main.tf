locals {
  id = lower(replace(var.id, " ", "_"))
}

resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  depends_on = [
    tls_private_key.tls_key
  ]

  key_name   = local.id
  public_key = tls_private_key.tls_key.public_key_openssh
}

resource "aws_ssm_parameter" "private_key" {
  name        = "/keyfiles/${var.id}/key.pem"
  description = "${var.desc} - Private Key"
  type        = "SecureString"
  value       = tls_private_key.tls_key.private_key_pem

  tags = {
    Env = "key"
    Type = "private"
  }
}

resource "aws_ssm_parameter" "public_key" {
  name        = "/keyfiles/${var.id}/key.pub"
  description = "${var.desc} - Public Key"
  type        = "String"
  value       = tls_private_key.tls_key.public_key_openssh

  tags = {
    Env = "key"
    Type = "public"
  }
}
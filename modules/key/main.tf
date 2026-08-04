resource "tls_private_key" "this" {
  count     = var.create ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "aws_key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.1.1"

  create     = var.create
  key_name   = var.key_name
  public_key = var.create ? trimspace(tls_private_key.this[0].public_key_openssh) : ""

  tags = var.tags
}

output "key_name" {
  value       = module.aws_key_pair.key_pair_name
  description = "The name of the created AWS key pair"
}

output "private_key_pem" {
  value       = var.create ? tls_private_key.this[0].private_key_pem : null
  sensitive   = true
  description = "The PEM-encoded private key. Only set when a new key pair is created."
}
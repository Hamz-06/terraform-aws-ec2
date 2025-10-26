resource "tls_private_key" "this" {
  algorithm = "RSA"
}

module "aws_key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.1.1"

  create     = var.create
  key_name   = var.key_name
  public_key = trimspace(tls_private_key.this.public_key_openssh)

  tags = var.tags
}

output "key_name" {
  value       = module.aws_key_pair.key_pair_name
  description = "The name of the created AWS key pair"
}
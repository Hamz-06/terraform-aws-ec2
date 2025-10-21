# modules/ec2/main.tf
module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.0"

  name                  = var.name
  ami                   = var.ami
  instance_type         = var.instance_type
  subnet_id             = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name              = var.key_name

  tags = var.tags
}

output "instance_id" {
  value = module.ec2.id
}

output "public_ip" {
  value = module.ec2.public_ip
}

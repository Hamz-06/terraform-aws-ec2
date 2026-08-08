# modules/ec2/main.tf
resource "aws_iam_policy" "ec2_custom" {
  for_each = var.create ? var.iam_policy_json_documents : {}

  name_prefix = "${var.instance_name}-${each.key}-"
  description = "Custom policy for ${var.instance_name} (${each.key})"
  policy      = each.value
  tags        = var.tags
}

locals {
  iam_role_policies = {
    for name, policy in aws_iam_policy.ec2_custom : name => policy.arn
  }
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 6.1.4"

  create                       = var.create
  name                         = var.instance_name
  ami                          = var.ami
  instance_type                = var.instance_type
  subnet_id                    = var.subnet_id
  vpc_security_group_ids       = var.security_group_ids
  key_name                     = var.key_name
  associate_public_ip_address  = var.associate_public_ip_address
  security_group_ingress_rules = var.security_group_ingress_rules
  ebs_volumes                  = var.ebs_volumes
  user_data                    = var.user_data
  create_iam_instance_profile  = length(local.iam_role_policies) > 0
  iam_role_policies            = local.iam_role_policies

  tags = var.tags
}

output "instance_id" {
  value = module.ec2.id
}

output "public_ip" {
  value = module.ec2.public_ip
}

output "private_ip" {
  value = module.ec2.private_ip
}

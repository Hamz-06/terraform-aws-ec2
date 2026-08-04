locals {
  name = "${var.environment}_${var.application_name}"
  required_tags = merge(var.tags, {
    environment      = var.environment
    application_name = var.application_name
  })

  # Determines if we should create a new key or use an existing one
  # mostly used for testing with existing keys
  create_new_key = var.ec2_key_name == null || var.ec2_key_name == ""
  ec2_key_name   = local.create_new_key ? module.ec2_key.key_name : var.ec2_key_name
}

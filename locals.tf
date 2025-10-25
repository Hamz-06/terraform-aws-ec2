locals {
  name = "${var.environment}_${var.application_name}"
  required_tags = merge(var.tags, {
    environment      = var.environment
    application_name = var.application_name
  })
}

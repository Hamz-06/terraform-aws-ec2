terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "ec2_key" {
  source   = "./modules/key"
  create   = local.create_new_key
  key_name = "${local.name}_key"

  tags = merge(local.required_tags, {
    "resource" = "${local.name}_key"
  })
}

module "ec2_instance" {
  source        = "./modules/ec2"
  create        = var.create
  instance_name = var.instance_name

  ami           = var.ami_id
  instance_type = var.instance_type
  # potentially have it passed in as variable instead of creating it by default
  subnet_id                    = var.subnet_id
  security_group_ids           = var.security_group_ids
  associate_public_ip_address  = var.associate_public_ip_address
  security_group_ingress_rules = var.security_group_ingress_rules
  ebs_volumes                  = var.ebs_volumes
  user_data                    = var.user_data

  key_name = local.ec2_key_name

  tags = merge(local.required_tags, {
    "resource" = "${local.name}_ec2"
  })
}

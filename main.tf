terraform {
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

// Determines if we should use an existing key or not
// mostly used for testing with existing keys
locals {
  create_new_key = var.ec2_key_name == null
  ec2_key_name   = local.create_new_key ? module.ec2_key.name : var.ec2_key_name
}

module "vpc" {
  source = "./modules/vpc"

  name            = var.vpc_name
  azs             = var.vpc_azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  cidr            = var.vpc_cidr

  tags = merge(local.required_tags, {
    "resource" = "${local.name}_vpc"
  })
}

module "ec2_key" {
  source = "./modules/key"

  key_name = "${local.name}_key"

  tags = merge(local.required_tags, {
    "resource" = "${local.name}_key"
  })
}

module "ec2_instance" {
  source        = "./modules/ec2"
  instance_name = var.instance_name

  ami           = var.ami_id
  instance_type = var.instance_type
  //potentially have it passed in as variable instead of creating it by default
  subnet_id                    = module.vpc.public_subnets[0]
  security_group_ids           = [module.vpc.default_security_group_id]
  associate_public_ip_address  = var.associate_public_ip_address
  security_group_ingress_rules = var.security_group_ingress_rules

  key_name = local.ec2_key_name

  tags = merge(local.required_tags, {
    "resource" = "${local.name}_ec2"
  })
  depends_on = [module.vpc]
}

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

module "vpc" {
  source = "./modules/vpc"

  name            = var.vpc_name
  azs             = var.vpc_azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
  cidr            = var.vpc_cidr
}

module "ec2_instance" {
  source = "./modules/ec2"

  name                         = var.instance_name
  ami                          = var.ami_id
  instance_type                = var.instance_type
  subnet_id                    = module.vpc.public_subnets[0]
  security_group_ids           = [module.vpc.default_security_group_id]
  associate_public_ip_address  = var.associate_public_ip_address
  security_group_ingress_rules = var.security_group_ingress_rules

  key_name = var.key_name
  tags     = var.tags

  depends_on = [module.vpc]
}

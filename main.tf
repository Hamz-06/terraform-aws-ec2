terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.17.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  name               = var.vpc_name
  azs                = var.vpc_azs
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  tags               = var.tags
  cidr = var.vpc_cidr
}

module "ec2_instance" {
  source = "./modules/ec2"

  name          = var.instance_name
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnets[0]
  security_group_ids = [module.vpc.default_security_group_id]
  key_name      = var.key_name
  tags          = var.tags
}

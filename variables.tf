variable "region" {
  description = "The AWS region where resources will be created (e.g., us-east-1)."
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC to create."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC (e.g., 10.0.0.0/16)."
  type        = string
}

variable "vpc_azs" {
  description = "List of availability zones to use for the VPC (e.g., [\"us-east-1a\", \"us-east-1b\"])."
  type        = list(string)
}

variable "public_subnets" {
  description = "List of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "private_subnets" {
  description = "List of CIDR blocks for the private subnets."
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT Gateway(s) for private subnets."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "If true, a single NAT Gateway will be created for all AZs."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to apply to all resources (e.g., { Environment = \"dev\" })."
  type        = map(string)
  default     = {}
}

variable "instance_name" {
  description = "Name for the EC2 instance."
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance (e.g., ami-0abcdef1234567890)."
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type (e.g., t3.micro)."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "The name of the AWS key pair to associate with the EC2 instance for SSH access."
  type        = string
  default     = ""
}

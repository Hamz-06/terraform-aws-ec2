# GLOBAL variables REQUIRED
variable "create" {
  description = "Whether to create the EC2 instance and associated resources."
  type        = bool
  default     = true
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be one of: dev, prod."
  }
}

variable "application_name" {
  description = "The name of the application being deployed."
  type        = string

  validation {
    condition     = length(var.application_name) >= 2 && length(var.application_name) <= 30
    error_message = "Project name must be between 2 and 30 characters long."
  }
}


# EC2 
variable "region" {
  description = "The AWS region where resources will be created (e.g., us-east-1)."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources (e.g., { ttl = \"200\" }). By default environment, application and resource tags are included."
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

variable "ec2_key_name" {
  description = "the name of the ec2 key pair to use, if no key is provided one will be created"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the EC2 instance."
  type        = bool
  default     = false
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be deployed."
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the instance."
  type        = list(string)
  default     = []
}

variable "security_group_ingress_rules" {
  description = "Map of security group ingress rules to apply to the EC2 instance."
  type = map(object({
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = optional(string)
    from_port                    = optional(number)
    ip_protocol                  = optional(string, "tcp")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    tags                         = optional(map(string), {})
    to_port                      = optional(number)
  }))
  default = {}
}

variable "user_data" {
  description = "Shell script to run on instance launch (user data). Use heredoc syntax for multiline scripts."
  type        = string
  default     = null
}

variable "ebs_volumes" {
  description = "Map of additional EBS volumes to attach to the EC2 instance. Map key is used as the device name if device_name is not set."
  type = map(object({
    device_name                    = optional(string)
    size                           = optional(number)
    type                           = optional(string, "gp3")
    iops                           = optional(number)
    throughput                     = optional(number)
    encrypted                      = optional(bool, true)
    kms_key_id                     = optional(string)
    snapshot_id                    = optional(string)
    multi_attach_enabled           = optional(bool)
    final_snapshot                 = optional(bool)
    force_detach                   = optional(bool)
    skip_destroy                   = optional(bool)
    stop_instance_before_detaching = optional(bool)
    tags                           = optional(map(string), {})
  }))
  default = {}
}


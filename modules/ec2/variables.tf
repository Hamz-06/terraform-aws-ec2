variable "create" {
  description = "Whether to create the EC2 instance"
  type        = bool
  default     = true
}

variable "instance_name" {
  description = "Name for the EC2 instance"
  type        = string
}

variable "ami" {
  description = "AMI ID to launch the instance with"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be deployed"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the instance"
  type        = list(string)
  default     = []
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = true
}

variable "security_group_ingress_rules" {
  description = "List of security group ingress rules"
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

variable "ebs_volumes" {
  description = "Map of additional EBS volumes to attach to the instance. Map key is used as the device name if device_name is not set."
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

variable "user_data" {
  description = "Shell script to run on instance launch (user data)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the instance"
  type        = map(string)
  default     = {}
}

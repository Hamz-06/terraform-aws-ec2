variable "name" {
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

variable "monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the instance"
  type        = map(string)
  default     = {}
}

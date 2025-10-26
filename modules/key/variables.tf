variable "tags" {
  description = "A map of tags to apply to all resources (e.g., { Environment = \"dev\" })."
  type        = map(string)
  default     = {}
}

variable "key_name" {
  description = "Name of the key pair"
  type        = string
}

variable "create" {
  description = "Determines whether resources will be created"
  type        = bool
  default     = true
}
# Terraform AWS EC2 Module

This is a Terraform module to create and manage AWS EC2 instances with customizable configurations including VPC, security groups, and key pairs.


## Usage

### Basic Example

```hcl
module "ec2_instance" {
  source  = "Hamz-06/ec2/aws"
  version = "2.0.0"

  # Required variables
  environment      = "dev"
  application_name = "web-app"
  region          = "us-east-1"
  instance_name   = "web-server"
  ami_id          = "ami-0abcdef1234567890"

  # Optional variables
  instance_type    = "t3.micro"
  ec2_key_name     = null  # Will create a new key pair
  
  tags = {
    Owner     = "engineering-team"
    CostCenter = "development"
  }
}
```

### Advanced Example with Custom Security Rules

```hcl
module "ec2_instance" {
  source = "github.com/yourusername/terraform-aws-ec2"

  environment      = "prod"
  application_name = "api-server"
  region          = "us-west-2"
  instance_name   = "api-prod"
  ami_id          = "ami-0abcdef1234567890"
  instance_type   = "t3.medium"

  security_group_ingress_rules = {
    http = {
      description = "HTTP traffic"
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    https = {
      description = "HTTPS traffic"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = {
    Environment = "production"
    Backup      = "daily"
  }
}
```

## Required Variables

| Name | Description | Type | Example |
|------|-------------|------|---------|
| `environment` | The deployment environment | `string` | `"dev"`, `"prod"` |
| `application_name` | The name of the application | `string` | `"web-app"` |
| `region` | AWS region for resources | `string` | `"us-east-1"` |
| `instance_name` | Name for the EC2 instance | `string` | `"web-server"` |
| `ami_id` | AMI ID for the EC2 instance | `string` | `"ami-0abcdef1234567890"` |


## Outputs

| Name | Description |
|------|-------------|
| `instance_id` | The ID of the EC2 instance |
| `public_ip` | The public IP address of the instance |
| `private_ip` | The private IP address of the instance |
| `key_pair_name` | The name of the SSH key pair |



## Development

### Helper Commit Messages

| Commit Message | Effect | Example |
|----------------|--------|---------|
| `fix:` | 🩹 Patch | `fix(network): correct CIDR block format` |
| `feat:` | 🔼 Minor | `feat(storage): add lifecycle rules support` |
| `BREAKING CHANGE:` | 💥 Major | `BREAKING CHANGE: switch to new S3 backend` |

To add a breaking change, include `BREAKING CHANGE:` in the commit body or footer.

example 

git commit -m "feat(infra): remove vpc module" \
           -m "BREAKING CHANGE: VPC module has been removed from infrastructure stack"
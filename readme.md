# terraform-aws-ec2

Terraform module to create and manage an AWS EC2 instance. Handles key pair generation, security groups, EBS volumes, and user data.

## Features

- Auto-generates an RSA-4096 SSH key pair if none is provided
- Creates and manages security group ingress rules
- Supports additional encrypted EBS volumes (gp3)
- Passes user data scripts for instance bootstrapping
- Consistent resource tagging via `environment` + `application_name`
- `create = false` to disable the instance without removing config

## Usage

### Minimal

```hcl
module "ec2" {
  source = "Hamz-06/ec2/aws"

  environment      = "dev"
  application_name = "web-app"
  region           = "eu-west-2"
  instance_name    = "web-server"
  ami_id           = "ami-0de87753593ec47fd"
  subnet_id        = "subnet-0bc588b1b44340e74"
}
```

### With SSH access and custom key

```hcl
module "ec2" {
  source = "Hamz-06/ec2/aws"

  environment      = "prod"
  application_name = "api-server"
  region           = "eu-west-2"
  instance_name    = "api-prod"
  ami_id           = "ami-0de87753593ec47fd"
  instance_type    = "t3.medium"
  subnet_id        = module.vpc.public_subnets[0]

  associate_public_ip_address = true
  ec2_key_name                = "my-existing-key"

  security_group_ingress_rules = {
    ssh = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = "203.0.113.0/24" # restrict to your IP
      description = "Allow SSH"
    }
    https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "Allow HTTPS"
    }
  }

  tags = {
    Owner      = "engineering"
    CostCenter = "platform"
  }
}
```

### With EBS volume and user data

```hcl
module "ec2" {
  source = "Hamz-06/ec2/aws"

  environment      = "dev"
  application_name = "k3s"
  region           = "eu-west-2"
  instance_name    = "k3s-node"
  ami_id           = "ami-0de87753593ec47fd"
  instance_type    = "t3.small"
  subnet_id        = module.vpc.public_subnets[0]

  ebs_volumes = {
    data = {
      device_name = "/dev/sdf"
      size        = 50
      type        = "gp3"
      encrypted   = true
    }
  }

  user_data = <<EOF
#!/bin/bash
while [ ! -b /dev/nvme1n1 ]; do sleep 1; done
mkfs.ext4 /dev/nvme1n1
mkdir -p /data
mount /dev/nvme1n1 /data
echo "/dev/nvme1n1 /data ext4 defaults,nofail 0 2" >> /etc/fstab
EOF
}
```

### With custom IAM policy (for EC2 role)

```hcl
module "ec2" {
  source = "Hamz-06/ec2/aws"

  environment      = "dev"
  application_name = "ai-cc"
  region           = "us-east-1"
  instance_name    = "ai-worker"
  ami_id           = "ami-0de87753593ec47fd"
  subnet_id        = module.vpc.private_subnets[0]

  iam_policy_json_documents = {
    ssm_parameter_read = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ssm:GetParameter",
            "ssm:GetParameters",
            "ssm:GetParametersByPath"
          ]
          Resource = "arn:aws:ssm:us-east-1:123456789012:parameter/dev/ai-cc/*"
        }
      ]
    })
  }
}
```

### Disable the instance without removing config

```hcl
module "ec2" {
  source = "Hamz-06/ec2/aws"
  create = false
  # ... rest of config unchanged
}
```

## Required Variables

| Name | Description | Type |
|------|-------------|------|
| `environment` | Deployment environment — `dev` or `prod` | `string` |
| `application_name` | Application name (2–30 chars) | `string` |
| `region` | AWS region (e.g. `eu-west-2`) | `string` |
| `instance_name` | Name for the EC2 instance | `string` |
| `ami_id` | AMI ID to launch the instance with | `string` |
| `subnet_id` | Subnet ID to deploy the instance into | `string` |

## Optional Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `create` | Whether to create the instance | `bool` | `true` |
| `instance_type` | EC2 instance type | `string` | `"t3.micro"` |
| `ec2_key_name` | Existing key pair name. If `null`, a new RSA-4096 key is generated | `string` | `null` |
| `associate_public_ip_address` | Assign a public IP to the instance | `bool` | `false` |
| `security_group_ids` | List of existing security group IDs to attach | `list(string)` | `[]` |
| `security_group_ingress_rules` | Map of ingress rules to create on the managed security group | `map(object)` | `{}` |
| `user_data` | Shell script to run on first boot | `string` | `null` |
| `ebs_volumes` | Map of additional EBS volumes to attach | `map(object)` | `{}` |
| `iam_policy_json_documents` | Map of IAM policy JSON documents to create and attach to EC2 IAM role | `map(string)` | `{}` |
| `tags` | Additional tags applied to all resources | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `instance_id` | ID of the EC2 instance |
| `instance_public_ip` | Public IP address (if assigned) |
| `instance_private_ip` | Private IP address |
| `key_name` | Name of the SSH key pair in use |
| `private_key_pem` | PEM private key — only set when the module generates the key pair (**sensitive**) |

## SSH Access

When the module generates a key pair, retrieve it after `terraform apply`:

```bash
terraform output -raw private_key_pem > key.pem && chmod 600 key.pem
ssh -i key.pem ec2-user@$(terraform output -raw instance_public_ip)
```

## Find the latest AMI for your region

```bash
aws ssm get-parameter \
  --region eu-west-2 \
  --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 \
  --query Parameter.Value \
  --output text
```

## Development

### Commit convention

| Prefix | Effect |
|--------|--------|
| `fix:` | Patch release |
| `feat:` | Minor release |
| `BREAKING CHANGE:` in commit body | Major release |



```bash
# Breaking change example
git commit -m "feat(ec2): remove auto-generated key pair support" \
           -m "BREAKING CHANGE: ec2_key_name is now required"
```

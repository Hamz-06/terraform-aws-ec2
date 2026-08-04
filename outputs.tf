output "instance_id" {
  value = module.ec2_instance.instance_id
}

output "instance_public_ip" {
  value = module.ec2_instance.public_ip
}

output "instance_private_ip" {
  value = module.ec2_instance.private_ip
}

output "key_name" {
  value = local.ec2_key_name
}

output "private_key_pem" {
  value     = module.ec2_key.private_key_pem
  sensitive = true
}

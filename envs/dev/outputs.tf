# VPC & Subnets #
output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_public_id" {
  value = module.network.subnet_public_id
}

output "subnet_private_id" {
  value = module.network.subnet_private_id
}


#SG #
output "web_sg_id" {
  value = module.security.web_sg_id
}

output "app_sg_id" {
  value = module.security.app_sg_id
}

output "db_sg_id" {
  value = module.security.db_sg_id
}

#TYLKO DO TESTOWANIA BEZ DNS
output "alb_dns_name" {
  description = "Public DNS name Application Load Balancera"
  value       = module.alb.dns_name
}
output "nameservers" {
  value = module.route53.name_servers
  sensitive   = false
}

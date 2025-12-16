# VPC & Subnets #
output "vpc_id" {
  value = local.deploy_full_stack ? module.network[0].vpc_id : null
}

output "subnet_public_id" {
  value = local.deploy_full_stack ? module.network[0].subnet_public_id : null
}

output "subnet_private_id" {
  value = local.deploy_full_stack ? module.network[0].subnet_private_id : null
}


#SG #
output "web_sg_id" {
  value = local.deploy_full_stack ? module.security[0].web_sg_id : null
}

output "app_sg_id" {
  value = local.deploy_full_stack ? module.security[0].app_sg_id : null
}

output "db_sg_id" {
  value = local.deploy_full_stack ? module.security[0].db_sg_id : null
}

#TYLKO DO TESTOWANIA BEZ DNS
output "alb_dns_name" {
  description = "Public DNS name Application Load Balancera"
  value       = local.deploy_full_stack ? module.alb[0].dns_name : null
}
output "nameservers" {
  value = module.route53.name_servers
  sensitive   = false
}

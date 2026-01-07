# VPC & Subnets #
output "vpc_id" {
  value = local.deploy_full_stack ? module.network[0].vpc_id : null
}

output "alb_subnet_ids" {
  value = local.deploy_full_stack ? module.network[0].alb_subnet_ids : null
}

output "frontend_subnet_ids" {
  value = local.deploy_full_stack ? module.network[0].frontend_subnet_ids : null
}

output "backend_subnet_ids" {
  value = local.deploy_full_stack ? module.network[0].backend_subnet_ids : null
}

output "db_subnet_ids" {
  value = local.deploy_full_stack ? module.network[0].db_subnet_ids : null
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

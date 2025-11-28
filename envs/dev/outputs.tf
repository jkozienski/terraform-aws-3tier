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

# #EC2 WEB INSTANCE #
# output "web_ec2_instance_id" {
#   value = module.ec2_service.web_ec2_instance_id
# }

# #EC2 APP INSTANCE #
# output "app_ec2_instance_id" {
#   value = module.ec2_service.app_ec2_instance_id
# }



#TYLKO DO TESTOWANIA BEZ DNS
output "alb_dns_name" {
  description = "Public DNS name Application Load Balancera"
  value       = module.alb.dns_name
}

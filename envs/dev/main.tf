# Network: VPC, Subnets, IGW, NAT, Route Tables#
module "network" {
  source         = "../../modules/network"
  environment    = var.environment
  cidr_block     = var.cidr_block
  subnet_public  = var.subnet_public
  subnet_private = var.subnet_private

  tags = {
    Project = var.project
  }
}


# SECURITY GROUPS #
module "security" {
  source      = "../../modules/security"
  environment = var.environment
  vpc_id      = module.network.vpc_id

  tags = {
    Project = var.project
  }
}

# IAM #
module "iam" {
  source      = "../../modules/iam"
  project     = var.project
  environment = var.environment

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}


#ZAKOMENTOWANE BO TESTUJE BEZ DNS
# Certificate ACM #
# module "acm" {
#   source      = "../../modules/acm"
#   domain_name = var.domain_name

#   tags = {
#     Project     = var.project
#     Environment = var.environment
#     Name = "${var.project}-${var.environment}-acm"
#   }
# }

# Route53 #
# module "route53" {
#   source = "../../modules/route53"

#   domain_name  = var.domain_name
#   alb_dns_name = module.alb.dns_name
#   alb_zone_id  = module.alb.zone_id

#   tags = {
#     Project = var.project
#     Environment = var.environment
#   }
# }


# Load  Balancer #
module "alb" {
  source = "../../modules/alb"

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.subnet_public_id

  project     = var.project
  environment = var.environment
  #acm_certificate_arn = module.acm.certificate_arn

  alb_sg_id = module.security.alb_sg_id

  tags = {
    Project     = var.project
    Environment = var.environment
    Name        = "${var.project}-${var.environment}-alb"
  }
}



# ASG #
module "web_asg" {
  source = "../../modules/asg"

  name             = "${var.project}-${var.environment}-web"
  ami_id           = var.ami_id_web
  instance_type    = var.instance_type_web
  key_name         = var.key_name
  root_volume_size = var.root_volume_size

  sg_id      = module.security.web_sg_id
  subnet_ids = module.network.subnet_public_id

  target_group_arns = [module.alb.frontend_tg_arn]

  instance_profile_arn = module.iam.instance_profile_arn

  project     = var.project
  environment = var.environment

  user_data = base64encode(
    templatefile("../../modules/asg/user_data_web.tpl", {
    })
  )

  tags = {
    Project     = var.project
    Environment = var.environment

  }
}


module "app_asg" {
  source = "../../modules/asg"

  name             = "${var.project}-${var.environment}-app"
  ami_id           = var.ami_id_app
  instance_type    = var.instance_type_app
  key_name         = var.key_name
  root_volume_size = var.root_volume_size

  sg_id      = module.security.app_sg_id
  subnet_ids = module.network.subnet_private_id

  target_group_arns = [module.alb.backend_tg_arn]

  instance_profile_arn = module.iam.instance_profile_arn

  project     = var.project
  environment = var.environment

  user_data = base64encode(
    templatefile("../../modules/asg/user_data_app.tpl", {
      app_env   = var.environment #pass environment to ansible playbook
      app_region   = var.region  #pass environment to ansible playbook
    })
  )

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}


# RDS #
module "database_rds" {
  source = "../../modules/rds"

  project     = var.project
  environment = var.environment

  subnet_ids = module.network.subnet_private_id
  db_sg_id   = module.security.db_sg_id

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  multi_az              = var.multi_az
  deletion_protection   = var.deletion_protection

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}




# SSM PARAMETERS #

locals {
  database_url = "postgres://${var.db_username}:${var.db_password}@${module.database_rds.endpoint}:5432/${var.db_name}"
}

module "api_ssm_parameters" {
  source = "../../modules/ssm_parameters"

  parameter_path_prefix = "/todolist/${var.environment}/api"

  #String
  string_parameters = var.string_parameters

  #SecureString
  securestring_parameters = {
    SECRET_KEY   = var.api_secret_key
    DATABASE_URL = local.database_url
  }
}



# EC2 INSTANCE #


# module "ec2_service" {
#   source               = "../../modules/ec2_service"
#   project              = var.project
#   environment          = var.environment

#   #WEB
#   ami_id_web                   = var.ami_id_web
#   instance_type_web        = var.instance_type_web
#   subnet_id_web            = module.network.subnet_public_id[0]
#   security_groups_web_id = module.security.web_sg_id
#   key_name             = var.key_name
#   root_volume_size     = var.root_volume_size

#   #APP
#   ami_id_app                   = var.ami_id_app
#   instance_type_app        = var.instance_type_app
#   subnet_id_app            = module.network.subnet_private_id[0]
#   security_groups_app_id = module.security.app_sg_id


#   #instance_profile_arn = var.instance_profile_arn

#    tags = merge(
#     {
#       Project = var.project
#     },
#     var.tags,

#    )
# }


locals {
  deploy_full_stack = !var.show_nameservers

  db_user     = urlencode(var.db_username)
  db_password = urlencode(var.db_password)

  database_url = local.deploy_full_stack ? "postgres://${local.db_user}:${local.db_password}@${module.database_rds[0].endpoint}/${var.db_name}" : null

}

# Network: VPC, Subnets, IGW, NAT, Route Tables #
module "network" {
  count = local.deploy_full_stack ? 1 : 0

  source                   = "../../modules/network"
  environment              = var.environment
  cidr_block               = var.cidr_block
  alb_subnet_public        = var.alb_subnet_public
  frontend_subnet_private  = var.frontend_subnet_private
  backend_subnet_private   = var.backend_subnet_private
  db_subnet_private        = var.db_subnet_private

  tags = {
    Project = var.project
  }
}


# SECURITY GROUPS #
module "security" {
  count = local.deploy_full_stack ? 1 : 0

  source      = "../../modules/security"
  environment = var.environment
  vpc_id      = local.deploy_full_stack ? module.network[0].vpc_id : null

  tags = {
    Project = var.project
  }
}

# IAM #
module "iam" {
  count = local.deploy_full_stack ? 1 : 0

  source      = "../../modules/iam"
  project     = var.project
  environment = var.environment

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}


# DNS Route53 #
module "route53" {
  source      = "../../modules/route53"

  domain_name          = var.domain_name
  alb_dns_name         = local.deploy_full_stack ? module.alb[0].dns_name : null
  alb_zone_id          = local.deploy_full_stack ? module.alb[0].zone_id : null
  create_alias_records = local.deploy_full_stack

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

# ACM #
module "acm" {
  count = local.deploy_full_stack ? 1 : 0

  source      = "../../modules/acm"
  domain_name = var.domain_name
  zone_id     = module.route53.zone_id

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}


# Load  Balancer #
module "alb" {
  count = local.deploy_full_stack ? 1 : 0

  source = "../../modules/alb"

  vpc_id            = local.deploy_full_stack ? module.network[0].vpc_id : null
  public_subnet_ids = local.deploy_full_stack ? module.network[0].alb_subnet_ids : null

  project     = var.project
  environment = var.environment
  acm_certificate_arn = local.deploy_full_stack ? module.acm[0].certificate_arn : null

  alb_sg_id = local.deploy_full_stack ? module.security[0].alb_sg_id : null

  tags = {
    Project     = var.project
    Environment = var.environment
    Name        = "${var.project}-${var.environment}-alb"
  }
}



# ASG #
module "web_asg" {
  count = local.deploy_full_stack ? 1 : 0

  source = "../../modules/asg"

  name             = "${var.project}-${var.environment}-web"
  ami_id           = var.ami_id_web
  instance_type    = var.instance_type_web
  key_name         = var.key_name
  root_volume_size = var.root_volume_size
  min_size         = var.min_size_web_asg
  max_size         = var.max_size_web_asg

  sg_id      = local.deploy_full_stack ? module.security[0].web_sg_id : null
  subnet_ids = local.deploy_full_stack ? module.network[0].frontend_subnet_ids : null

  target_group_arns = local.deploy_full_stack ? [module.alb[0].frontend_tg_arn] : []

  instance_profile_arn = local.deploy_full_stack ? module.iam[0].instance_profile_arn : null

  project     = var.project
  environment = var.environment

  user_data = base64encode(
    templatefile("../../modules/asg/user_data_web.tpl", {
      source_repo_url = var.source_repo_url
      infra_repo_url = var.infra_repo_url
    })
  )

  tags = {
    Project     = var.project
    Environment = var.environment

  }
}

# ASG #  
module "app_asg" {
  count = local.deploy_full_stack ? 1 : 0

  source = "../../modules/asg"

  name             = "${var.project}-${var.environment}-app"
  ami_id           = var.ami_id_app
  instance_type    = var.instance_type_app
  key_name         = var.key_name
  root_volume_size = var.root_volume_size
  min_size         = var.min_size_app_asg
  max_size        = var.max_size_app_asg

  sg_id      = local.deploy_full_stack ? module.security[0].app_sg_id : null
  subnet_ids = local.deploy_full_stack ? module.network[0].backend_subnet_ids : null

  target_group_arns = local.deploy_full_stack ? [module.alb[0].backend_tg_arn] : []

  instance_profile_arn = local.deploy_full_stack ? module.iam[0].instance_profile_arn : null

  project     = var.project
  environment = var.environment

  user_data = base64encode(
    templatefile("../../modules/asg/user_data_app.tpl", {
      app_env   = var.environment #pass to ansible playbook
      app_region   = var.region  #pass to ansible playbook
      ssm_prefix = "/${var.project}/${var.environment}/api"
      source_repo_url = var.source_repo_url
      infra_repo_url = var.infra_repo_url
    })
  )

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}


# RDS #
module "database_rds" {
  count = local.deploy_full_stack ? 1 : 0

  source = "../../modules/rds"

  project     = var.project
  environment = var.environment

  subnet_ids = local.deploy_full_stack ? module.network[0].db_subnet_ids : null
  db_sg_id   = local.deploy_full_stack ? module.security[0].db_sg_id : null

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
module "api_ssm_parameters" {
  count = local.deploy_full_stack ? 1 : 0

  source = "../../modules/ssm_parameters"

  parameter_path_prefix = "/${var.project}/${var.environment}/api"

  #String
  string_parameters = var.string_parameters

  #SecureString
  securestring_parameters = {
    SECRET_KEY   = var.api_secret_key
    DATABASE_URL = local.database_url
  }
}




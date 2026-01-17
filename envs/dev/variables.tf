variable "region" {
  type = string
}
variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "alb_subnet_public" {
  type = list(string)
}

variable "frontend_subnet_private" {
  type = list(string)
}

variable "backend_subnet_private" {
  type = list(string)
}

variable "db_subnet_private" {
  type = list(string)
}

variable "domain_name" {
  type = string
}

variable "show_nameservers" {
  description = "Show nameservers before deploy architecture."
  type        = bool
  default     = false
}


# ASG VARIABLES #
variable "key_name" {
  type = string
}

variable "root_volume_size" {
  type = number
}

variable "ami_id_web" {
  type = string
}

variable "instance_type_web" {
  type = string
}

variable "ami_id_app" {
  type = string
}

variable "instance_type_app" {
  type = string
}

variable "min_size_web_asg" {
  type        = number
}

variable "max_size_web_asg" {
  type        = number
}


variable "min_size_app_asg" {
  type        = number
}

variable "max_size_app_asg" {
  type        = number
}

variable "instance_profile_arn" {
  type    = string
  default = null
}

variable "source_repo_url" {
  description = "Git repository containing full application (frontend + backend)"
  type        = string
}

variable "infra_repo_url" {
  description = "Git repository containing terraform and ansible code for infrastructure setup"
  type        = string
}




# RDS
variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "max_allocated_storage" {
  type = number
}

variable "multi_az" {
  type = bool
}

variable "deletion_protection" {
  type = bool
}



# SSM PARAMETERS #
variable "string_parameters" {
  type = map(string)
}

variable "api_secret_key" {
  type      = string
  sensitive = true
}













variable "tags" {
  type    = map(string)
  default = {}
}

# #  EC2  INSTANCE VARIABLES #
# variable "ami_id_web" {
#   type        = string
# }

# variable "ami_id_app" {
#   type        = string
# }

# variable "instance_type_web" {
#   type        = string
#   default     = "t3.micro"
# }

# variable "instance_type_app" {
#   type        = string
#   default     = "t3.micro"
# }


# variable "key_name" {
#   type        = string
# }

# variable "root_volume_size" {
#   type        = number
#   default     = 8
# }

# variable "instance_profile_arn" {
#   type        = string
# }

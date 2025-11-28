variable "project" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "name" {
  type        = string
}

variable "ami_id" {
  type        = string
}

variable "instance_type" {
  type        = string
}

variable "key_name" {
  type        = string
}

variable "root_volume_size" {
  type        = number
}

variable "sg_id" {
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
}

variable "target_group_arns" {
  type        = list(string)
}

variable "instance_profile_arn" {
  type        = string
  default     = null
}


variable "min_size" {
  type        = number
  default     = 1
}

variable "max_size" {
  type        = number
  default     = 1
}

variable "desired_capacity" {
  type        = number
  default     = 1
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "user_data" {
  type    = string
  default = ""
}
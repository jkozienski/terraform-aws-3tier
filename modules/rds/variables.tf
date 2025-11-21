variable "project" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
}

variable "db_sg_id" {
  type        = string
}

variable "db_name" {
  type        = string
}

variable "username" {
  type        = string
}

variable "password" {
  type        = string
  sensitive   = true
}

variable "engine" {
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  type        = string
  default     = "15.10"
}

variable "instance_class" {
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  type        = number
  default     = 100
}


variable "multi_az" {
  type        = bool
  default     = false
}

variable "deletion_protection" {
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  default     = {}
}

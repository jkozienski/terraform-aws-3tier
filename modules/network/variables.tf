variable "environment" {
  type = string
}

variable "cidr_block" {
  type    = string
}

variable "alb_subnet_public" {
  type    = list(string)
  default = []
}

variable "frontend_subnet_private" {
  type    = list(string)
  default = []
}

variable "backend_subnet_private" {
  type    = list(string)
  default = []
}

variable "db_subnet_private" {
  type    = list(string)
  default = []
}

variable "tags" {
  type        = map(string)
  default     = {}
}

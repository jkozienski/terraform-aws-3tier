variable "vpc_id" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "alb_sg_id" {
  type        = string
  default    = null
}


variable "ssh_cidr_blocks" {
  type        = list(string)

  default = [
    "157.158.136.112/32",
    "185.25.121.234/32",
  ]
}

variable "tags" {
  type        = map(string)
  default     = {}
}
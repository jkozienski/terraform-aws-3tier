variable "domain_name" {
  type = string
}

variable "alb_dns_name" {
  type    = string
  default = null
}

variable "alb_zone_id" {
  type    = string
  default = null
}

variable "create_alias_records" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

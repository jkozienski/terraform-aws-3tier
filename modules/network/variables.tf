variable "environment" {
  type = string
}

variable "cidr_block" {
  type    = string
}

variable "subnet_public" {
  type    = list(string)
  default     = []
}

variable "subnet_private" {
  type    = list(string)
  default     = []
}

variable "tags" {
  type        = map(string)
  default     = {}
}
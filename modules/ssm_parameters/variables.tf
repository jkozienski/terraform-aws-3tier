variable "parameter_path_prefix" {
  type        = string
}

variable "string_parameters" {
  type        = map(string)
  default     = {}
}

variable "securestring_parameters" {
  type        = map(string)
  default     = {}
}

variable "tags" {
  type        = map(string)
  default     = {}
}
# GENERAL
variable "project" {
  type        = string
  description = "The project name"
}

variable "environment" {
  type        = string
  description = "The environment name"
}

variable "component" {
  type        = string
  description = "The TF component name"
}

variable "module" {
  type        = string
  description = "The module name"
  default     = "example"
}

variable "default_tags" {
  type        = map
  description = "Default tags to be applied to all taggable resources"
  default     = {}
}

# SPECIFIC
# ...

variable "stack_name" {
  type        = string
  description = "Name of the CloudFormation stack"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "fleet_name" {
  type = string
  default = "webforx-vdi-fleet"
}

variable "session_timeout" {
  type    = string
  default = "240"
}

variable "enable_autoscaling" {
  type    = string
  default = "true"
}

variable "min_capacity" {
  type    = string
  default = "1"
}

variable "desired_capacity" {
  type    = string
  default = "2"
}

variable "max_capacity" {
  type    = string
  default = "5"
}

variable "environment" {
  type    = string
  default = "sandbox"
}

variable "project" {
  type    = string
  default = "appstream-vdi"
}

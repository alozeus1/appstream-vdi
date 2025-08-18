variable "stack_name" {
  type        = string
  description = "Name of the CloudFormation stack"
  default     = "webforx-appstream-vdi"
}

variable "vpc_id" {
  type        = string
  description = "Target VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnets for the fleet"
}

variable "security_group_id" {
  type        = string
  description = "Existing SG to reuse. If null, module will create one."
  default     = null
}

variable "fleet_name" {
  type        = string
  description = "AppStream Fleet name"
  default     = "webforx-vdi-fleet"
}

variable "min_capacity" {
  type        = number
  description = "Minimum capacity"
  default     = 0
}

variable "desired_capacity" {
  type        = number
  description = "Desired capacity"
  default     = 0
}

variable "max_capacity" {
  type        = number
  description = "Maximum capacity"
  default     = 5
}

variable "enable_autoscaling" {
  type        = bool
  description = "Enable scaling policy block in CFT"
  default     = true
}

variable "max_user_session_duration_hours" {
  type        = number
  description = "Max user session length in hours"
  default     = 4
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to apply"
  default     = {}
}

variable "environment" {
  type        = string
  description = "Environment name (sandbox|stage|prod|network)"
  default     = "sandbox"
}

variable "project" {
  type        = string
  description = "Project tag"
  default     = "appstream-vdi"
}

variable "fleet_instance_type" {
  type        = string
  description = "Instance type for the AppStream fleet (currently unused)"
  default     = "stream.standard.medium"
}

variable "builder_instance_type" {
  type        = string
  description = "Instance type for the Image Builder (currently unused)"
  default     = "stream.standard.large"
}

variable "business_hours_cron_start_utc" {
  type        = string
  description = "Cron expression to start fleet during business hours (currently unused)"
  default     = "cron(0 13 * * ? *)"
}

variable "after_hours_cron_stop_utc" {
  type        = string
  description = "Cron expression to stop fleet after hours (currently unused)"
  default     = "cron(0 22 * * ? *)"
}

variable "stack_name" {
  type        = string
  description = "CloudFormation stack name"
  default     = "webforx-appstream-vdi"
}

variable "vpc_id" {
  type        = string
  description = "Target VPC ID"
  validation {
    condition     = can(regex("^vpc-([0-9a-f]{8}|[0-9a-f]{17})$", var.vpc_id))
    error_message = "vpc_id must look like vpc-xxxxxxxx or vpc-xxxxxxxxxxxxxxxxx (hex)."
  }
}

# variables.tf
variable "subnet_ids" {
  type        = list(string)
  description = "Provide at least one subnet ID (we will use the first one)"
  validation {
    condition     = length(var.subnet_ids) >= 1 && alltrue([for id in var.subnet_ids : can(regex("^subnet-([0-9a-f]{8}|[0-9a-f]{17})$", id))])
    error_message = "Provide at least one valid subnet-id."
  }
}

variable "security_group_id" {
  type        = string
  description = "Existing SG to reuse. If null, Terraform will create one."
  default     = null
}

variable "fleet_name" {
  type        = string
  description = "AppStream Fleet name"
  default     = "webforx-vdi-fleet"
}

variable "fleet_instance_type" {
  type        = string
  description = "Fleet instance type"
  default     = "stream.standard.medium"
}

variable "fleet_image_arn" {
  type        = string
  description = "Image ARN for the Fleet. If empty, BaseImageArn is used (must not be empty in that case)."
  default     = ""
}

variable "builder_instance_type" {
  type        = string
  description = "Image Builder instance type"
  default     = "stream.standard.large"
}

variable "base_image_arn" {
  type        = string
  description = "Optional base image ARN for ImageBuilder. If empty, ImageBuilder is skipped."
  default     = ""
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
  description = "Enable step scaling + schedules"
  default     = true
}

variable "business_hours_cron_start_utc" {
  type        = string
  description = "UTC cron to scale up at business start"
  default     = "cron(0 13 * * ? *)"
}

variable "after_hours_cron_stop_utc" {
  type        = string
  description = "UTC cron to scale to zero after hours"
  default     = "cron(0 22 * * ? *)"
}

variable "max_user_session_duration_hours" {
  type        = number
  description = "Max user session length in hours"
  default     = 4
}

variable "create_appstream_service_role" {
  type        = bool
  description = "Create the AmazonAppStreamServiceAccess service role"
  default     = true
}

variable "create_appautoscaling_slr" {
  type        = bool
  description = "Create the Application Auto Scaling SLR for AppStream fleets"
  default     = false
}

variable "environment" {
  type        = string
  description = "Environment tag"
  default     = "sandbox"
}

variable "project" {
  type        = string
  description = "Project tag"
  default     = "appstream-vdi"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}

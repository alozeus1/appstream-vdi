variable "region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = "Optional named profile for local runs"
  default     = null
}

provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

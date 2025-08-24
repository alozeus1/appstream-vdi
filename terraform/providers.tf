provider "aws" {
  region  = local.env.region
  profile = var.aws_profile
}

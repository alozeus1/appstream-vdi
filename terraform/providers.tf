provider "aws" {
  region  = try(local.env.region, var.region)
  profile = var.aws_profile

  default_tags {
    tags = local.merged_tags
  }
}

locals {
  merged_tags = merge(
    {
      Name        = local.env.project
      Environment = local.env.environment
      App         = "appstream-vdi"
      ManagedBy   = "Terraform"
      Project     = local.env.project
      Owner       = try(local.env.owner, "webforx-ops")
      CostCenter  = try(local.env.cost_center, "default-cc")
    },
    local.env.tags,
    var.tags
  )
}

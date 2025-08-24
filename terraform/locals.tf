locals {
  # Merge tags from environment configs, variables, and enterprise defaults
  merged_tags = merge(
    {
      Name        = try(local.env.stack_name, var.stack_name)
      Environment = try(local.env.environment, var.environment)
      App         = "appstream-vdi"
      ManagedBy   = "Terraform"
      Project     = try(local.env.project, var.project)
      Owner       = try(local.env.owner, "webforx-ops")
      CostCenter  = try(local.env.cost_center, "default-cc")
    },
    try(local.env.tags, {}),
    var.tags
  )
}

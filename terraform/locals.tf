locals {
  region_file = "${path.root}/environments/region.yaml"
  env_file    = "${path.root}/environments/${var.environment}.yaml"

  base         = try(yamldecode(file(local.region_file)), {})
  env_specific = try(yamldecode(file(local.env_file)), {})

  env = merge(local.base, local.env_specific)

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

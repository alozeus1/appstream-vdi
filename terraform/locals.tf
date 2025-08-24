locals {
  # Load region-wide defaults
  base = yamldecode(file("${path.module}/../environments/region.yml"))

  # Load environment-specific overrides
  env_specific = yamldecode(file("${path.module}/../environments/webforx-management.yaml"))

  # Merge them together (env-specific wins if keys overlap)
  env = merge(local.base, local.env_specific)
}

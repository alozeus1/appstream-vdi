data "aws_subnet" "primary" {
  id = local.primary_subnet_id
}

locals {
  primary_subnet_in_vpc = data.aws_subnet.primary.vpc_id == try(local.env.vpc_id, var.vpc_id)
}
locals {
  primary_subnet_id = try(local.env.subnet_ids[0], var.subnet_ids[0])
}

# Create a minimal egress SG if none provided
resource "aws_security_group" "appstream_sg" {
  count       = try(local.env.security_group_id, var.security_group_id) == null ? 1 : 0
  name        = "${try(local.env.project, var.project)}-${try(local.env.environment, var.environment)}-appstream-sg"
  description = "Security group for AppStream fleet"
  vpc_id      = try(local.env.vpc_id, var.vpc_id)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.merged_tags
}
locals {
  effective_sg_id = coalesce(
    try(local.env.security_group_id, null),
    var.security_group_id,
    try(aws_security_group.appstream_sg[0].id, null)
  )
}

# Defensive lookups & preconditions
data "aws_vpc" "selected" { id = try(local.env.vpc_id, var.vpc_id) }

data "aws_subnet" "selected" {
  for_each = toset(try(local.env.subnet_ids, var.subnet_ids))
  id       = each.value
}

# --- Service-Linked Roles (global, one-time per account) ---
# AppStream 2.0 SLR (creates AWSServiceRoleForAppStream)
resource "aws_iam_role" "appstream_service_role" {
  count       = var.create_appstream_service_role ? 1 : 0
  name        = "AmazonAppStreamServiceAccess"
  path        = "/service-role/"
  description = "Service role for AppStream 2.0"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "appstream.amazonaws.com" }
    }]
  })

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "appstream_service_role_attach" {
  count      = var.create_appstream_service_role ? 1 : 0
  role       = aws_iam_role.appstream_service_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAppStreamServiceAccess"
}

# --- Application Auto Scaling SLR for AppStream fleets ---
resource "aws_iam_service_linked_role" "appautoscaling_appstream" {
  count            = var.create_appautoscaling_slr ? 1 : 0
  aws_service_name = "appstream.application-autoscaling.amazonaws.com"
  description      = "Service-linked role so Application Auto Scaling can scale AppStream Fleets"
}
resource "aws_cloudformation_stack" "appstream_stack" {
  name         = var.stack_name
  capabilities = ["CAPABILITY_NAMED_IAM"]

  template_body = file("${path.module}/../cft/appstream-stack.yaml")

  parameters = {
    VPCId                      = var.vpc_id
    SubnetId                   = local.primary_subnet_id
    SecurityGroupId            = local.effective_sg_id
    FleetName                  = var.fleet_name
    FleetInstanceType          = var.fleet_instance_type
    FleetImageArn              = var.fleet_image_arn != "" ? var.fleet_image_arn : var.base_image_arn
    BuilderInstanceType        = var.builder_instance_type
    BaseImageArn               = var.base_image_arn
    MinCapacity                = tostring(var.min_capacity)
    DesiredCapacity            = tostring(var.desired_capacity)
    MaxCapacity                = tostring(var.max_capacity)
    MaxUserSessionDurationSecs = tostring(var.max_user_session_duration_hours * 3600)
    EnableAutoScaling          = var.enable_autoscaling ? "true" : "false"
    BusinessHoursCronStartUTC  = var.business_hours_cron_start_utc
    AfterHoursCronStopUTC      = var.after_hours_cron_stop_utc
  }
  lifecycle {
    # must provide an image for the fleet
    precondition {
      condition     = (var.fleet_image_arn != "" || var.base_image_arn != "")
      error_message = "Set fleet_image_arn or base_image_arn so the Fleet has an image."
    }
    # subnets must belong to the VPC
    precondition {
      condition     = local.primary_subnet_in_vpc
      error_message = "All subnet_ids must belong to vpc_id = ${var.vpc_id}."
    }
    # at least 2 AZs recommended
    precondition {
      condition     = local.primary_subnet_in_vpc
      error_message = "Provide subnets in at least 2 Availability Zones."
    }
  }

  #    It's fine to reference resources that use count; Terraform handles the 0/1 case.
  depends_on = [
    aws_security_group.appstream_sg,
    aws_iam_role.appstream_service_role,
    aws_iam_service_linked_role.appautoscaling_appstream,
  ]

  tags = local.merged_tags
}

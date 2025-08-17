terraform {
  required_version = "~> 1.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }
}

resource "aws_security_group" "appstream_sg" {
  count       = var.security_group_id == null ? 1 : 0
  name        = "appstream-sg"
  description = "Security group for AppStream fleet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "appstream-sg"
    Environment = var.environment
  }
}

locals {
  effective_sg_id = var.security_group_id != null ? var.security_group_id : aws_security_group.appstream_sg[0].id
}

resource "aws_cloudformation_stack" "appstream_stack" {
  name          = var.stack_name
  template_body = file("${path.module}/../cft/appstream-stack.yaml")

  parameters = {
    VPCId             = var.vpc_id
    SubnetIds         = join(",", var.subnet_ids)
codex/modify-security-group-creation-logic-in-terraform
    SecurityGroupId   = local.effective_sg_id
main
    FleetName         = var.fleet_name
    SessionTimeout    = var.session_timeout
    EnableAutoScaling = var.enable_autoscaling
    DesiredCapacity   = var.desired_capacity
    MinCapacity       = var.min_capacity
    MaxCapacity       = var.max_capacity
  }

  capabilities = ["CAPABILITY_NAMED_IAM"]

  tags = {
    Environment = var.environment
    Project     = var.project
    Owner       = "webforx-devops"
  }
}

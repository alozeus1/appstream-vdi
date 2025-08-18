output "security_group_id" {
  description = "Security Group used by the fleet"
  value       = local.effective_sg_id
}

output "cfn_stack_id" {
  description = "CloudFormation stack ID"
  value       = aws_cloudformation_stack.appstream_stack.id
}

output "cfn_outputs" {
  description = "All CloudFormation outputs"
  value       = aws_cloudformation_stack.appstream_stack.outputs
}

output "fleet_name" {
  description = "AppStream Fleet Name"
  value       = coalesce(aws_cloudformation_stack.appstream_stack.outputs["FleetName"], var.fleet_name)
}


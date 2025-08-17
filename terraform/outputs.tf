output "security_group_id" {
  description = "Security Group used by the fleet"
  value       = local.effective_sg_id
}

output "cfn_stack_id" {
  description = "CloudFormation stack ID"
  value       = aws_cloudformation_stack.appstream.id
}

output "cfn_stack_status" {
  description = "CloudFormation stack status"
  value       = aws_cloudformation_stack.appstream.outputs["StackStatus"]
  sensitive   = false
}

# Surface FleetName from CFN outputs if the template sets it
output "fleet_name" {
  description = "AppStream Fleet Name"
  value       = coalesce(aws_cloudformation_stack.appstream.outputs["FleetName"], var.fleet_name)
}

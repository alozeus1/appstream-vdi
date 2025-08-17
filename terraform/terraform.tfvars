stack_name   = "webforx-appstream-vdi"
region       = "us-east-1"
environment  = "sandbox"
project      = "appstream-vdi"

vpc_id       = "vpc-xxxxxxxx"
subnet_ids   = ["subnet-aaaaaaa", "subnet-bbbbbbb"]

# Uncomment to reuse an existing SG instead of creating one
# security_group_id = "sg-xxxxxxxx"

fleet_name    = "webforx-vdi-fleet"
min_capacity  = 0
desired_capacity = 0
max_capacity  = 5

enable_autoscaling               = true
max_user_session_duration_hours  = 4

tags = {
  Owner      = "DevOps"
  CostCenter = "WFT-001"
  Compliance = "Internal"
}

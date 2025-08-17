stack_name   = "webforx-appstream-vdi"
region       = "us-east-1"
environment  = "sandbox"
project      = "appstream-vdi"

vpc_id     = "vpc-xxxxxxxx"
subnet_ids = ["subnet-aaaaaaa", "subnet-bbbbbbb"]

# Optional: reuse an existing SG
# security_group_id = "sg-xxxxxxxx"

fleet_name          = "webforx-vdi-fleet"
fleet_instance_type = "stream.standard.medium"
builder_instance_type = "stream.standard.large"

# Start cost-safe
min_capacity     = 0
desired_capacity = 0
max_capacity     = 5

# Create Image Builder ONLY if you set this next value:
# (see 'Find a base image' below)
# base_image_arn = "arn:aws:appstream:us-east-1:aws:image/<latest-windows-image>"

# 4-hour max session
max_user_session_duration_hours = 4

# Simple default schedule: 9AM ET scale-up (min>=1), 6PM ET scale-down (to 0)
business_hours_cron_start_utc = "cron(0 13 * * ? *)" # 13:00 UTC = 9AM ET
after_hours_cron_stop_utc     = "cron(0 22 * * ? *)" # 22:00 UTC = 6PM ET

tags = {
  Owner      = "DevOps"
  CostCenter = "WFT-001"
  Compliance = "Internal"
}

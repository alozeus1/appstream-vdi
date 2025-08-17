# Webforx AppStream VDI Deployment

This repository contains the infrastructure code and CloudFormation template for deploying AWS AppStream 2.0 in a sandbox or production environment using Terraform.

---

## 📁 Repo Structure

appstream-vdi/
├── cft/
│ └── appstream-stack.yaml # CloudFormation template (VDI Fleet & Scaling)
├── terraform/
│ ├── main.tf # Terraform deployment of the CFT stack
│ ├── variables.tf
│ ├── terraform.tfvars
│ ├── outputs.tf
├── README.md


---

## ⚙️ Features

- 🚀 Deploys AWS AppStream fleet using Terraform + CloudFormation
- ⏱️ Configurable session timeout (default 4 hours)
- 📉 Auto scaling support (min/max/desired)
- 🔐 Security group created automatically
- 🌐 Prepared for Authentik SAML SSO integration

---

## 🧱 Prerequisites

- AWS CLI + credentials set
- Terraform v1.3+
- Access to an AWS environment (sandbox or prod)
- VPC + Subnets created beforehand

---

## Variables
### Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `stack_name` | string | `webforx-appstream-vdi` | CloudFormation stack name |
| `region` | string | `us-east-1` | AWS region |
| `aws_profile` | string \| null | `null` | Named profile for local runs |
| `vpc_id` | string | n/a | Target VPC |
| `subnet_ids` | list(string) | n/a | Subnets for fleet |
| `security_group_id` | string \| null | `null` | Reuse SG if provided; otherwise created |
| `fleet_name` | string | `webforx-vdi-fleet` | AppStream Fleet name |
| `min_capacity` | number | `0` | Min instances |
| `desired_capacity` | number | `0` | Desired instances |
| `max_capacity` | number | `5` | Max instances |
| `enable_autoscaling` | bool | `true` | Toggle scaling block in CFT |
| `max_user_session_duration_hours` | number | `4` | Max session hours |
| `tags` | map(string) | `{}` | Extra resource tags |
| `environment` | string | `sandbox` | Env tag |
| `project` | string | `appstream-vdi` | Project tag |


## 🪜 Usage Instructions

### 1. Clone the Repo

```bash
git clone https://git.edusuc.net/WEBFORX/appstream-vdi.git
cd appstream-vdi/terraform
```
2. Configure Variables

Edit terraform.tfvars:
```hcl
stack_name         = "webforx-appstream-vdi"
vpc_id             = "vpc-xxxxxx"
subnet_ids         = ["subnet-aaaa", "subnet-bbbb"]
```
3. Deploy Stack
```sh
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## Parameters You Can Customize

All values in variables.tf can be modified dynamically via terraform.tfvars:

    -   session_timeout (default: 240 mins)

    -   fleet_name

    -   min_capacity, desired_capacity, max_capacity

    -   enable_autoscaling
-   
## Next Steps (Coming Soon)

 - **SAML Authentik Integration**

 - **Home Folder (S3-backed persistent storage)**

 - **Session scripts (Pre & Post)**

 - **CloudWatch logging**

 - **AppStream ImageBuilder + Custom image support**

##Maintained by

Webforx DevOps Team
**For internal use and training environments.**

## License

Proprietary - Webforx Technology Limited


---

Let me know if:
- You want me to **refactor your full original CFT** to support all features
- You’d like the README converted to GitLab-style format or Markdown preview with visuals

Just upload your full CFT if you still have it — and I’ll rebuild it Terraform-compatible.

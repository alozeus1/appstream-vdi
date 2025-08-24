# terraform/backend.tf
terraform {
  backend "s3" {
    bucket         = "terraform-s3-bucket-statefile"
    key            = "appstream-vdi/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-tf-lock"
    encrypt        = true
  }
}

# terraform/backend.tf
terraform {
  backend "s3" {
    bucket         = "your-tfstate-bucket"
    key            = "appstream-vdi/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tfstate-locks"
    encrypt        = true
  }
}

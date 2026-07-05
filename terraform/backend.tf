terraform {
  backend "s3" {
    bucket         = "buildmasters-tfstate-prod"
    key            = "terraform/monitoring-stack/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "monitoring-stack-dev-lock"
  }
}

terraform {
  required_version = ">= 0.13"
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "ze-terraform-state"
    key            = "ze/main.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-zedelivery"
  }
}
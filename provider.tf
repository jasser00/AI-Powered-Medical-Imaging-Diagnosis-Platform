terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.79"
    }
  }
  backend "s3" {
    bucket         = "my-remote-state-pfa-bucket-jasser"
    key            = "test/terraform.tfstate"
    dynamodb_table = "state-locking"
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

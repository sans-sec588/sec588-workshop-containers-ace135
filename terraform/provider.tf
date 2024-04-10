terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.37.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

terraform {
  required_version = ">= 1.6.0"
}

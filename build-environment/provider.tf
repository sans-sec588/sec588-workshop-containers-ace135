#######################################################################################
# Terraform provider block, please put all required packages here
#######################################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Hashicorp AWS Provider
      version = "~> 5.37.0"     # Version at time of build
    }
    time = {
      source  = "hashicorp/time" # Hashicorp Time Provider, needed for sleep.
      version = "0.11"           # Hashicorp Version 0.11
    }
    null = {
      source  = "hashicorp/null" # Hashicorp Null Provider
      version = "3.2.2"          # Hashicorp Null Provider at time of build
    }
  }
}

#######################################################################################
# AWS Provider specific info
#######################################################################################
provider "aws" {
  region  = var.region  # This is the region to build items in 
  profile = var.profile # This is the AWS Profile to use
}
#######################################################################################
# Terraform Provider Specific Info
#######################################################################################
terraform {
  required_version = ">= 1.6.0" # This is the minimum version of terraform.
}

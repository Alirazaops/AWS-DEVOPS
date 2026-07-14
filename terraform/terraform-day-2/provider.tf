terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.53.0"
      #version = "<6.53.0"
      #version = "<4.0.0, >=3.0.0" #provider version

    }
  }
}


provider "aws" {
  region = "us-east-1"
}
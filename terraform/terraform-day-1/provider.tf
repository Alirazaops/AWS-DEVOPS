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

terraform {
  required_version = ">= 1.5.0" #terraform version
}

provider "aws" {
    region = "us-west-2" #if required, you can also set the region in the provider block and change the region
}
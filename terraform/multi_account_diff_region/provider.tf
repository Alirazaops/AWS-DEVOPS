provider "aws" {
    profile = "dev-account"
    alias = "dev"
    region = "us-east-1"  
}

provider "aws" {
    profile = "test-account"
    alias = "test"
    region = "us-west-2"  
}
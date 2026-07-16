resource "aws_vpc" "prd" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "prd"
    }
  
}

resource aws_s3_bucket "my_bucket" {
    bucket = "my-terraform-fewddssbucketccccccccccccccccccccc"
    depends_on = [ aws_vpc.prd ]
  
}

#dependency block is used to specify the dependencies between resources in Terraform. 
#It allows you to define the order in which resources should be created or destroyed, 
#ensuring that resources are created or destroyed in the correct order. 
#This can be useful when you have resources that depend on each other, 
#such as a VPC and an S3 bucket that needs to be created after the VPC is created.
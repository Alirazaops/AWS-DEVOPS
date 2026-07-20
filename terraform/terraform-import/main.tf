resource "aws_instance" "prd" {
    ami = "ami-01edba92f9036f76e"
    instance_type = "t2.medium"
    tags = {
        Name = "server"
    }
    # Terraform Import
   #terraform import aws_instance.prd i-0963b0f13bced357a(instance id)
}

resource "aws_s3_bucket" "prd_bucket" {
    bucket = "aatika-terraform-dev-init"
  #terraform import aws_s3_bucket.prd_bucket aatika-terraform-dev-init
}

resource "aws_s3_bucket_versioning" "prd_bucket_versioning" {
    bucket = aws_s3_bucket.prd_bucket.id
    versioning_configuration {
      status =  "Enabled"
    }
  #terraform import aws_s3_bucket_versioning.prd_bucket_versioning aatika-terraform-dev-init
}
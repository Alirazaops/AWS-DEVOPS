resource "aws_s3_bucket" "dev-account-1" {
    bucket = "aatika-dev-account"
    provider = aws.dev
  
}

resource "aws_s3_bucket" "test-account-1" {
    bucket = "aatika-test-account"
    provider = aws.test
  
}
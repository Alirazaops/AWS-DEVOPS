resource "aws_iam_role" "lambda_role" {
    name = "lambda_execution_role_s3"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }]
    })
  
}


resource "aws_iam_role_policy_attachment" "lambda_policy" {
    role = aws_iam_role.lambda_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

                  
    #existing AWS managed policy for Lambda execution
  
}

data "archive_file" "lambda_zip_1" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function.zip"
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "my-lambda-bucket-aatika"
}

resource "aws_s3_object" "lambda_zip" {
    bucket = aws_s3_bucket.lambda_bucket.id
    key = "lambda_function.zip" 
    source = data.archive_file.lambda_zip_1.output_path
    etag = filemd5(data.archive_file.lambda_zip_1.output_path) 
    #data.archive_file.lambda_zip_1.output_path
}

resource "aws_lambda_function" "prd_lambda_function" {
    function_name = "my_lambda_function_1"
    role = aws_iam_role.lambda_role.arn
    handler = "lambda_function.lambda_handler"
    runtime = "python3.12"
    s3_bucket = aws_s3_bucket.lambda_bucket.id
    s3_key = aws_s3_object.lambda_zip.key
  
}
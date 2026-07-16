resource "aws_iam_role" "lambda_role" {
    name = "lambda_execution_role"
    
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


resource "aws_lambda_function" "prd_lambda_function" {
  function_name     = "my_lambda_function"
  role              = aws_iam_role.lambda_role.arn
  handler           = "lambda_function.lambda_handler"
  runtime           = "python3.12"
  timeout           = 900
  memory_size       = 128
  filename          = "lambda_function.zip" 
  source_code_hash = filebase64sha256("lambda_function.zip") #whenever the code in the ZIP file changes, this hash will change, and Terraform will know to update the Lambda function with the new code.

  #Without source_code_hash, Terraform might not detect when the code in the ZIP file has changed — meaning your Lambda might not update even after uploading a new ZIP.

  #This hash is a checksum that triggers a deployment.
}

resource "aws_cloudwatch_event_rule" "lambde_schedule" {
    name = "lambda_schedule_rule"
    description = "Trigger Lambda every 5 minutes"
    schedule_expression = "cron(0/5 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_target" {
    rule = aws_cloudwatch_event_rule.lambde_schedule.name
    target_id = "lambda_schedule_target"
    arn = aws_lambda_function.prd_lambda_function.arn
    

}

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.prd_lambda_function.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.lambde_schedule.arn
  
}
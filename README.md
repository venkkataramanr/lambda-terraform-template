# terraform-aws-lambda

This Terraform module creates and uploads an AWS Lambda function and hides the ugly parts from you.

## Features

* Creates a lambda function with source code referred from s3
* Creates a standard IAM role
  * You can add additional policies if required.
* uploads the zipped source code to s3 and uses it for lambda build

## Requirements

* Python 3.6 or higher

## Terraform version compatibility

0.12.18 and above

## Usage

```
module "test_lambda" {
  source = "../"

  function_name = "test_function"
  project_name  = "test_project_name"
  handler_name  = "handler.test"
  bucket        = "test_bucket"
  runtime       = "python3.6"
  timeout       = "30"
  memory_size   = "128"
  tags          = "${local.tags}"

  vpc_config = {
    subnet_ids         = ["subnet-xxaa", "subnet-yybb"]
    security_group_ids = ["sg-aabb"]
  }

  tracing_config = {
    mode = "Active"
  }

  environment = {
    variables = {
      key = "value"
    }
  }

  policy_document = "${data.aws_iam_policy_document.policy_document.json}"

}

data "aws_iam_policy_document" "policy_document" {
  statement {
    resources = ["arn:aws:s3:::prefix*"]
    actions = ["s3:PutObject"]
  }
  statement {
    actions = [
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets",
      "xray:GetSamplingStatisticSummaries",
      "EC2:CreateNetworkInterface",
      "EC2:DescribeNetworkInterfaces",
      "EC2:DeleteNetworkInterface",
      "logs:*",
      "cloudwatch:*"
    ]
    resources = ["*"]
  }
}


```

## Inputs


| Name | Description | Type | Required |
|------|-------------|------|----------|
| function\_name | The function name of lambda | `string` | yes |
| project\_name | A project name to be used as prefix in function_name, role and policy | `string` | yes |
| handler\_name | The name of the main handler function | `string` | yes |
| bucket | Bucket where the source code of the lambda would be uploaded | `string` | yes |
| runtime | The lambda run time environment | `string` | yes |
| timeout | timeout in seconds for the lambda function | `string` | yes |
| memory_size | memory to be allocated for the lambda function in MB | `string` | yes |
| tags | List of tags for tagging the function | `list(string)` | yes |
| vpc_config | The netrowk subnet and security group config for the lambda | `object{map}` | no |
| tracing_config | X-ray tracing enable/disable flag for the lambda | `object{map}` | no |
| environment | X-ray tracing enable/disable flag for the lambda | `object{object{map}}` | no |
| policy_document | A policy document json for the lambda execution role| `object{object{map}}` | yes |


## Outputs

| Name | Description |
|------|-------------|
| lambda\_arn | The ARN of the Lambda function |
| function\_name | The name of the Lambda function |
| role\_arn | The ARN of the IAM role created for the Lambda function |

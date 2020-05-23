module "test_function" {
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


resource "aws_lambda_function" "lambda_function" {
  s3_bucket         = "${var.bucket}"
  s3_key            = aws_s3_bucket_object.lambda_function_code.id
  s3_object_version = aws_s3_bucket_object.lambda_function_code.version_id
  source_code_hash  = filebase64sha256("../../../functions/.archives/${var.function_identifier}.zip")
  function_name     = "${var.project_name}_${var.function_identifier}_handler"
  role              = aws_iam_role.lambda_function.arn
  handler           = "${var.handler_name}"
  runtime           = "${var.runtime}"
  timeout           = "${var.timeout}"
  memory_size       = "${var.memory_size}"
  tags              = "${var.tags}"

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config == null ? [] : [var.tracing_config]
    content {
      mode = tracing_config.value.mode
    }
  }

  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]
    content {
      variables = environment.value.variables
    }
  }
}

resource "aws_s3_bucket_object" "lambda_function_code" {
  bucket = "${var.bucket}"
  key    = "lambda_packages/${var.function_identifier}.zip"
  source = "../../../functions/.archives/${var.function_identifier}.zip"
  etag   = "${filemd5("../../../functions/.archives/${var.function_identifier}.zip")}"
}

resource "aws_iam_role_policy" "lambda_function" {
  name   = "${var.project_name}-${var.function_identifier}"
  role       = aws_iam_role.lambda_function.id
  policy = "${var.policy_document}"
}

resource "aws_iam_role" "lambda_function" {
  name               = "${var.project_name}-${var.function_identifier}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


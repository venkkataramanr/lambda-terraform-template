output "iam_role_arn" {
  value       = "${aws_iam_role.lambda_function.arn}"
  description = "The Amazon Resource Name (ARN) of the lambda execution role."
}

output "lambda_arn" {
  value       = "${aws_lambda_function.lambda_function.arn}"
  description = "The Amazon Resource Name (ARN) of the lambda function."
}

output "function_name" {
  value = "${aws_lambda_function.lambda_function.function_name}"
  description = "The Function Name of the lambda function."
}




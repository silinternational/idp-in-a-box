output "function_arn" {
  value = "${aws_lambda_function.search.arn}"
}

output "role_arn_for_remote_execution" {
  value = "${aws_iam_role.assumeRole.arn}"
}
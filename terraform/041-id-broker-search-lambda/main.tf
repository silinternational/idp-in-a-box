resource "aws_lambda_function" "search" {
  filename      = "${path.module}/idp-id-broker-search.zip"
  function_name = "${var.function_name}"
  handler       = "${var.function_name}"
  memory_size   = "${var.memory_size}"
  role          = "${var.role_arn}"
  runtime       = "go1.x"
  timeout       = "${var.timeout}"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = "${filebase64sha256("${path.module}/idp-id-broker-search.zip")}"

  environment {
    variables = {
      BROKER_BASE_URL = "${var.broker_base_url}"
      BROKER_TOKEN    = "${var.broker_token}"
    }
  }

  vpc_config {
    security_group_ids = ["${var.security_group_ids}"]
    subnet_ids         = ["${var.subnet_ids}"]
  }

  tags {
    idp_name = "${var.idp_name}"
    app_name = "${var.app_name}"
    app_env  = "${var.app_env}"
  }
}

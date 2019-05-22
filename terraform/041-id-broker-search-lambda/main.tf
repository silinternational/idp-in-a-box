resource "aws_lambda_function" "search" {
  s3_bucket     = "${var.function_bucket_name}"
  s3_key        = "${var.function_zip_name}"
  function_name = "${var.function_name}-${var.idp_name}"
  handler       = "${var.function_name}"
  memory_size   = "${var.memory_size}"
  role          = "${var.role_arn}"
  runtime       = "go1.x"
  timeout       = "${var.timeout}"

  environment {
    variables = {
      BROKER_BASE_URL = "${var.broker_base_url}"
      BROKER_TOKEN    = "${var.broker_token}"
      IDP_NAME        = "${var.idp_name}"
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

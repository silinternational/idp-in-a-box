data "http" "function-checksum" {
  url = "https://${var.function_bucket_name}.s3.amazonaws.com/${var.function_zip_name}.sum"
}

resource "aws_iam_role" "functionRole" {
  name               = "${var.idp_name}-${var.app_name}-${var.app_env}-lambda-function-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = "${aws_iam_role.functionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_lambda_function" "search" {
  s3_bucket        = "${var.function_bucket_name}"
  s3_key           = "${var.function_zip_name}"
  source_code_hash = "${data.http.function-checksum.body}"
  function_name    = "${var.function_name}-${var.idp_name}"
  handler          = "${var.function_name}"
  memory_size      = "${var.memory_size}"
  role             = "${aws_iam_role.functionRole.arn}"
  runtime          = "go1.x"
  timeout          = "${var.timeout}"

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

data "template_file" "remoteExecutePolicy" {
  filename = "${file("${path.module}/remote-execute-policy.json")}"
  vars {
    remote_role_arn = "${var.remote_role_arn}"
    function_arn    = "${aws_lambda_function.search.arn}"
  }
}

resource "aws_iam_role" "lambdaRemoteExecute" {
  name               = "${var.idp_name}-${var.app_name}-${var.app_env}-lambda-remote-execute"
  assume_role_policy = "${data.template_file.remoteExecutePolicy.rendered}"
}
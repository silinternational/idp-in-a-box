variable "app_env" {
  type = string
}

variable "app_name" {
  type    = string
  default = "idp-id-broker-search"
}

variable "broker_base_url" {
  type = string
}

variable "broker_token" {
  type = string
}

variable "function_bucket_name" {
  type = string
}

variable "function_zip_name" {
  type    = string
  default = "idp-id-broker-search.zip"
}

variable "function_name" {
  type    = string
  default = "idp-id-broker-search"
}

variable "idp_name" {
  type = string
}

variable "lambda_runtime" {
  description = "AWS Lambda runtime environment, either `provided.al2` or `go1.x`. `go1.x` is deprecated"
  default     = "go1.x"
  type        = string
}

variable "memory_size" {
  type    = string
  default = "128"
}

variable "remote_role_arn" {
  description = "ARN to role from different AWS account to be given permission to invoke function"
  type        = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "timeout" {
  type    = string
  default = "5"
}

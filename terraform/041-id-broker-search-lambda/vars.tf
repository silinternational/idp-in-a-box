variable "app_env" {
  type = "string"
}

variable "app_name" {
  default = "idp-id-broker-search"
}

variable "broker_base_url" {
  type = "string"
}

variable "broker_token" {
  type = "string"
}

variable "function_bucket_name" {
  type = "string"
}

variable "function_zip_name" {
  default = "idp-id-broker-search.zip"
}

variable "function_name" {
  default = "idp-id-broker-search"
}

variable "idp_name" {
  type = "string"
}

variable "memory_size" {
  default = "128"
}

variable "role_arn" {
  type = "string"
}

variable "security_group_ids" {
  type = "list"
}

variable "subnet_ids" {
  type = "list"
}

variable "timeout" {
  default = "5"
}

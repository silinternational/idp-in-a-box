module "search" {
  source = "../terraform/041-id-broker-search-lambda"

  app_env              = ""
  app_name             = ""
  broker_base_url      = ""
  broker_token         = ""
  function_bucket_name = ""
  function_name        = ""
  function_zip_name    = ""
  idp_name             = ""
  memory_size          = ""
  remote_role_arn      = ""
  security_group_ids   = [""]
  subnet_ids           = [""]
  timeout              = ""
}

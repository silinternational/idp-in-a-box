module "ssp" {
  source = "../terraform/060-simplesamlphp"

  admin_email                 = ""
  admin_name                  = ""
  alb_dns_name                = ""
  alb_https_listener_arn      = ""
  analytics_id                = ""
  app_env                     = ""
  app_name                    = ""
  cloudflare_domain           = ""
  cloudwatch_log_group_name   = ""
  cpu                         = ""
  create_dns_record           = true
  db_name                     = ""
  desired_count               = ""
  docker_image                = ""
  ecsServiceRole_arn          = ""
  ecs_cluster_id              = ""
  enable_debug                = ""
  help_center_url             = ""
  hub_mode                    = ""
  id_broker_access_token      = ""
  id_broker_assert_valid_ip   = ""
  id_broker_base_uri          = ""
  id_broker_trusted_ip_ranges = [""]
  idp_name                    = ""
  logging_level               = ""
  memory                      = ""
  mfa_learn_more_url          = ""
  mfa_setup_url               = ""
  mysql_host                  = ""
  mysql_pass                  = ""
  mysql_user                  = ""
  password_change_url         = ""
  password_forgot_url         = ""
  profile_url                 = ""
  recaptcha_key               = ""
  recaptcha_secret            = ""
  remember_me_secret          = ""
  secret_salt                 = ""
  show_saml_errors            = ""
  subdomain                   = ""
  theme_color_scheme          = ""
  trusted_ip_addresses        = [""]
  vpc_id                      = ""
}

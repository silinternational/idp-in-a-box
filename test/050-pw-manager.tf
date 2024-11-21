module "pw" {
  source = "../terraform/050-pw-manager"

  alb_dns_name                        = ""
  alb_https_listener_arn              = ""
  alerts_email                        = ""
  api_subdomain                       = ""
  app_env                             = ""
  app_name                            = ""
  auth_saml_checkResponseSigning      = ""
  auth_saml_entityId                  = ""
  auth_saml_idpCertificate            = ""
  auth_saml_requireEncryptedAssertion = ""
  auth_saml_signRequest               = ""
  auth_saml_sloUrl                    = ""
  auth_saml_spCertificate             = ""
  auth_saml_spPrivateKey              = ""
  auth_saml_ssoUrl                    = ""
  cloudflare_domain                   = ""
  cloudwatch_log_group_name           = ""
  code_length                         = ""
  cpu                                 = ""
  create_dns_record                   = true
  db_name                             = ""
  desired_count                       = ""
  docker_image                        = ""
  ecsServiceRole_arn                  = ""
  ecs_cluster_id                      = ""
  email_service_accessToken           = ""
  email_service_assertValidIp         = ""
  email_service_baseUrl               = ""
  email_service_validIpRanges         = [""]
  email_signature                     = ""
  extra_hosts                         = ""
  help_center_url                     = ""
  id_broker_access_token              = ""
  id_broker_assertValidBrokerIp       = ""
  id_broker_base_uri                  = ""
  id_broker_validIpRanges             = [""]
  idp_display_name                    = ""
  idp_name                            = ""
  memory                              = ""
  mysql_host                          = ""
  mysql_pass                          = ""
  mysql_user                          = ""
  password_rule_enablehibp            = ""
  password_rule_maxlength             = ""
  password_rule_minlength             = ""
  password_rule_minscore              = ""
  recaptcha_key                       = ""
  recaptcha_secret                    = ""
  support_email                       = ""
  support_feedback                    = ""
  support_name                        = ""
  support_phone                       = ""
  support_url                         = ""
  ui_subdomain                        = ""
  vpc_id                              = ""
}

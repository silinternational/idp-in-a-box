module "cluster" {
  source = "../terraform/010-cluster"

  app_name                 = ""
  app_env                  = ""
  aws_instance             = { a = "b" }
  aws_zones                = [""]
  cert_domain_name         = ""
  cloudflare_domain        = ""
  create_nat_gateway       = true
  ecs_cluster_name         = ""
  ecs_instance_profile_id  = ""
  idp_name                 = ""
  asg_additional_user_data = ""
  tags                     = {}
}

module "default_cluster" {
  source = "../terraform/000-core"

  cert_domain  = "example.com"
  cluster_name = "test-cluster-1"
}

module "create_acm_cert" {
  source = "../terraform/000-core"

  cert_domain     = "example.com"
  create_acm_cert = true
  cluster_name    = "test-cluster-2"
}

module "no_create_user" {
  source = "../terraform/000-core"

  cert_domain    = "example.com"
  create_cd_user = false
  cluster_name   = "test-cluster-3"
}

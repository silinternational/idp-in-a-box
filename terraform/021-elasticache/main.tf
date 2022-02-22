/*
 * Create Memcache cluster
 */
module "memcache" {
  source               = "github.com/silinternational/terraform-modules//aws/elasticache/memcache?ref=5.0.0"
  cluster_id           = "${var.app_name}-${var.app_env}-cache"
  security_group_ids   = var.security_group_ids
  subnet_group_name    = "${var.app_name}-${var.app_env}-cache-subnet"
  subnet_ids           = var.subnet_ids
  availability_zones   = var.availability_zones
  app_name             = var.app_name
  app_env              = var.app_env
  node_type            = var.node_type
  port                 = var.port
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = var.parameter_group_name
  az_mode              = var.az_mode
}


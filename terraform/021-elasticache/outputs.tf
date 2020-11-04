/*
 * Elasticache outputs
 */
output "cache_nodes" {
  value = module.memcache.cache_nodes
}

output "cache_configuration_endpoint" {
  value = module.memcache.configuration_endpoint
}

output "cache_cluster_address" {
  value = module.memcache.cluster_address
}


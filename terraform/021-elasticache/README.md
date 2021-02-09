# 021-elasticache - Create a Elasticache cluster of Memcache servers
This module is used to create an Elasticache cluster of memcache servers

## What this does

 - Create Elasticache subnet group spanning all provided `var.subnet_ids`.
 - Create Elasticache cluster of memcache servers.

## Required Inputs

 - `app_name` - Application name to be tagged to cluster as `app_name`.
 - `app_env` - Application environment to be tagged to cluster as `app_env`.
 - `security_group_ids` - List of security group IDs to place cluster in
 - `subnet_ids` - List of subnet ids for subnet group.
 - `availability_zones` - List of availability zones to place cluster in.

### Optional Inputs

 - `node_type` - Instance node type. Default: `cache.t2.micro`
 - `port` - Memcache port. Default: `11211`
 - `num_cache_nodes` - Number of cache nodes. Default: `2`
 - `parameter_group_name` - Name of Memcache parameter group to use. Default: `default.memcached1.4`
 - `az_mode` - Whether or not to use multiple zones. Default: `cross-az`. For single use `single-az`.

## Outputs

 - `cache_nodes` - List of cache nodes.
 - `cache_configuration_endpoint` - Memcache configuration endpoint.
 - `cache_cluster_address` - DNS name for cache clusters without port.

## Usage Example

```hcl
module "elasticache" {
  source             = "github.com/silinternational/idp-in-a-box//terraform/021-elasticache"
  security_group_ids = [data.terraform_remote_state.cluster.vpc_default_sg_id]
  subnet_ids         = data.terraform_remote_state.cluster.private_subnet_ids
  availability_zones = data.terraform_remote_state.cluster.aws_zones
  app_name           = var.app_name
  app_env            = var.app_env
}
```

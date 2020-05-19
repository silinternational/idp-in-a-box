variable "app_name" {
  type = string
}

variable "app_env" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "node_type" {
  type    = string
  default = "cache.t2.micro"
}

variable "port" {
  type    = string
  default = "11211"
}

variable "num_cache_nodes" {
  type    = string
  default = 2
}

variable "parameter_group_name" {
  type    = string
  default = "default.memcached1.5"
}

variable "az_mode" {
  type    = string
  default = "cross-az"
}


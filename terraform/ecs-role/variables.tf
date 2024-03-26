variable "name" {
  description = "name of role"
  type        = string
}

variable "policy" {
  description = "ECS role policy"
  type        = string
  default     = ""
}

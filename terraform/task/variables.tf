variable "ecs_cluster_arn" {
  description = "ecs cluster ID"
  type        = string
}

variable "task_definition_arn" {
  description = "ECS task definition ARN"
  type        = string
}

variable "name" {
  description = "name of event assigned to "
  type        = string
}

variable "event_schedule" {
  description = "event schedule in AWS EventBridge format"
  type        = string
  default     = "cron(0 0 * * ? *)"
}

variable "enable" {
  description = "enable the event rule"
  type        = bool
  default     = true
}

variable "event_rule_description" {
  description = "custom event rule description, if omitted, the description will be \"Start var.name task\"."
  type        = string
  default     = ""
}

variable "event_target_input" {
  description = "event target input, e.g.: {\"containerOverrides\":[{\"name\":\"container_name\",\"command\":[\"bin/console\",\"scheduled-task\"]}]}. See https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerOverride.html for more information."
  type        = string
  default     = null
}

variable "tags" {
  description = "AWS tags to add to the aws_cloudwatch_event_rule"
  type        = map(string)
  default     = null
}

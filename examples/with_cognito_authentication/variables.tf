variable "namespace" {
  type        = string
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  default     = "eg"
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = "testing"
}

variable "name" {
  type        = string
  description = "Application or solution name (e.g. `app`)"
  default     = "ecs"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-2"
}

variable "default_container_image" {
  type        = string
  description = "The default container image to use in container definition"
  default     = "nginxdemos/hello:latest"
}

variable "certificate_arn" {
  type        = string
  description = "SSL certificate ARN for ALB HTTPS endpoints"
}

variable "cognito_user_pool_arn" {
  type        = string
  description = "Cognito User Pool ARN"
}

variable "cognito_user_pool_client_id" {
  type        = string
  description = "Cognito User Pool Client ID"
}

variable "cognito_user_pool_domain" {
  type        = string
  description = "Cognito User Pool Domain"
}

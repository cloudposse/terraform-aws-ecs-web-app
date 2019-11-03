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

variable "google_oidc_client_id" {
  type        = string
  description = "Google OIDC Client ID. Use this URL to create a Google OAuth 2.0 Client and obtain the Client ID and Client Secret: https://console.developers.google.com/apis/credentials"
}

variable "google_oidc_client_secret" {
  type        = string
  description = "Google OIDC Client Secret. Use this URL to create a Google OAuth 2.0 Client and obtain the Client ID and Client Secret: https://console.developers.google.com/apis/credentials"
}

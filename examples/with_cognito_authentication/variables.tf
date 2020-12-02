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

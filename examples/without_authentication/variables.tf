variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-2"
}

variable "certificate_arn" {
  type        = string
  description = "SSL certificate ARN for ALB HTTPS endpoints"
}

variable "default_container_image" {
  type        = string
  description = "The default container image to use in container definition"
  default     = "nginxdemos/hello:latest"
}

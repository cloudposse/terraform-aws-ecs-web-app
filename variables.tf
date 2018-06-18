variable "name" {
  type        = "string"
  description = "Name (unique identifier for app or service)"
}

variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "delimiter" {
  type        = "string"
  description = "The delimiter to be used in labels."
  default     = "-"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "attributes" {
  type        = "list"
  description = "List of attributes to add to label."
  default     = []
}

variable "tags" {
  type        = "map"
  description = "Map of key-value pairs to use for tags."
  default     = {}
}

variable "vpc_id" {
  type        = "string"
  description = "The VPC ID where resources are created."
}

variable "listener_arns" {
  type        = "list"
  description = "List of ALB Listener ARNs for the ECS service."
}

variable "listener_arns_count" {
  type        = "string"
  description = "Number of elements in list of ALB Listener ARNs for the ECS service."
}

variable "aws_logs_region" {
  type        = "string"
  description = "The region for the AWS Cloudwatch Logs group."
}

variable "ecs_cluster_arn" {
  type = "string"
  description = "The ECS Cluster ARN where ECS Service will be provisioned."
}

variable "ecs_cluster_name" {
  type = "string"
  description = "The ECS Cluster Name to use in ECS Code Pipeline Deployment step."
}

variable "ecs_security_group_ids" {
  type = "list"
  description = "Additional Security Group IDs to allow into ECS Service."
  default = []
}

variable "ecs_private_subnet_ids" {
  type = "list"
  description = "List of Private Subnet IDs to provision ECS Service onto."
}

variable "github_oauth_token" {
  type        = "string"
  description = "GitHub Oauth Token with permissions to access private repositories"
}

variable "repo_owner" {
  type        = "string"
  description = "GitHub Organization or Username."
}

variable "repo_name" {
  type        = "string"
  description = "GitHub repository name of the application to be built and deployed to ECS."
}

variable "branch" {
  type        = "string"
  description = "Branch of the GitHub repository, e.g. master"
}

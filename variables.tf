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

variable "codepipeline_enabled" {
  type        = "string"
  description = "A boolean to enable/disable AWS Codepipeline and ECR"
  default     = "true"
}

variable "container_image" {
  type        = "string"
  description = "The default container image to use in container definition."
  default     = "cloudposse/default-backend"
}

variable "container_memory" {
  type        = "string"
  description = "The amount of RAM to allow container to use in MB."
  default     = "128"
}

variable "container_port" {
  type        = "string"
  description = "The port number on the container bound to assigned host_port."
  default     = "80"
}

variable "host_port" {
  type        = "string"
  description = "The port number to bind container_port to on the host"
  default     = ""
}

variable "launch_type" {
  type = "string"
  description = "The ECS launch type (valid options: FARGATE or EC2)"
  default = "FARGATE"
}
variable "protocol" {
  type        = "string"
  description = "The protocol used for the port mapping. Options: tcp or udp."
  default     = "tcp"
}

variable "healthcheck" {
  type        = "map"
  description = "A map containing command (string), interval (duration in seconds), retries (1-10, number of times to retry before marking container unhealthy, and startPeriod (0-300, optional grace period to wait, in seconds, before failed healthchecks count toward retries)"
  default     = {}
}

variable "alb_ingress_healthcheck_path" {
  type = "string"
  description = "The path of the healthcheck which the ALB checks."
  default = "/"
}

variable "alb_ingress_paths" {
  type        = "list"
  default     = []
  description = "Path pattern to match (a maximum of 1 can be defined), at least one of hosts or paths must be set"
}

variable "alb_ingress_hosts" {
  type        = "list"
  default     = []
  description = "Hosts to match in Hosts header, at least one of hosts or paths must be set"
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
  type        = "string"
  description = "The ECS Cluster ARN where ECS Service will be provisioned."
}

variable "ecs_cluster_name" {
  type        = "string"
  description = "The ECS Cluster Name to use in ECS Code Pipeline Deployment step."
}

variable "ecs_security_group_ids" {
  type        = "list"
  description = "Additional Security Group IDs to allow into ECS Service."
  default     = []
}

variable "ecs_private_subnet_ids" {
  type        = "list"
  description = "List of Private Subnet IDs to provision ECS Service onto."
}

variable "github_oauth_token" {
  type        = "string"
  description = "GitHub Oauth Token with permissions to access private repositories"
  default     = ""
}

variable "repo_owner" {
  type        = "string"
  description = "GitHub Organization or Username."
  default     = ""
}

variable "repo_name" {
  type        = "string"
  description = "GitHub repository name of the application to be built and deployed to ECS."
  default     = ""
}

variable "branch" {
  type        = "string"
  description = "Branch of the GitHub repository, e.g. master"
  default     = ""
}

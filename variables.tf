variable "name" {
  type        = "string"
  description = "Name (unique identifier for app or service)"
}

variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `eg` or `cp`)"
}

variable "delimiter" {
  type        = "string"
  description = "The delimiter to be used in labels"
  default     = "-"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "attributes" {
  type        = "list"
  description = "List of attributes to add to label"
  default     = []
}

variable "tags" {
  type        = "map"
  description = "Map of key-value pairs to use for tags"
  default     = {}
}

variable "codepipeline_enabled" {
  type        = "string"
  description = "A boolean to enable/disable AWS Codepipeline and ECR"
  default     = "true"
}

variable "container_image" {
  type        = "string"
  description = "The default container image to use in container definition"
  default     = "cloudposse/default-backend"
}

variable "container_cpu" {
  type        = "string"
  description = "The vCPU setting to control cpu limits of container. (If FARGATE launch type is used below, this must be a supported vCPU size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html)"
  default     = "256"
}

variable "container_memory" {
  type        = "string"
  description = "The amount of RAM to allow container to use in MB. (If FARGATE launch type is used below, this must be a supported Memory size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html)"
  default     = "512"
}

variable "container_memory_reservation" {
  type        = "string"
  description = "The amount of RAM (Soft Limit) to allow container to use in MB. This value must be less than container_memory if set"
  default     = ""
}

variable "container_port" {
  type        = "string"
  description = "The port number on the container bound to assigned host_port"
  default     = "80"
}

variable "port_mappings" {
  type        = "list"
  description = "The port mappings to configure for the container. This is a list of maps. Each map should contain \"containerPort\", \"hostPort\", and \"protocol\", where \"protocol\" is one of \"tcp\" or \"udp\". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort"

  default = [{
    "containerPort" = 80
    "hostPort"      = 80
    "protocol"      = "tcp"
  }]
}

variable "desired_count" {
  type        = "string"
  description = "The desired number of tasks to start with. Set this to 0 if using DAEMON Service type. (FARGATE does not suppoert DAEMON Service type)"
  default     = "1"
}

variable "host_port" {
  type        = "string"
  description = "The port number to bind container_port to on the host"
  default     = ""
}

variable "launch_type" {
  type        = "string"
  description = "The ECS launch type (valid options: FARGATE or EC2)"
  default     = "FARGATE"
}

variable "environment" {
  type        = "list"
  description = "The environment variables for the task definition. This is a list of maps"
  default     = []
}

variable "secrets" {
  type        = "list"
  description = "The secrets for the task definition. This is a list of maps"
  default     = []
}

variable "protocol" {
  type        = "string"
  description = "The protocol used for the port mapping. Options: `tcp` or `udp`"
  default     = "tcp"
}

variable "healthcheck" {
  type        = "map"
  description = "A map containing command (string), interval (duration in seconds), retries (1-10, number of times to retry before marking container unhealthy, and startPeriod (0-300, optional grace period to wait, in seconds, before failed healthchecks count toward retries)"
  default     = {}
}

variable "health_check_grace_period_seconds" {
  type        = "string"
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200. Only valid for services configured to use load balancers"
  default     = "0"
}

variable "alb_target_group_arn" {
  type        = "string"
  description = "Pass target group down to module"
  default     = ""
}

variable "alb_target_group_alarms_enabled" {
  type        = "string"
  description = "A boolean to enable/disable CloudWatch Alarms for ALB Target metrics"
  default     = "false"
}

variable "alb_target_group_alarms_3xx_threshold" {
  type        = "string"
  description = "The maximum number of 3XX HTTPCodes in a given period for ECS Service"
  default     = "25"
}

variable "alb_target_group_alarms_4xx_threshold" {
  type        = "string"
  description = "The maximum number of 4XX HTTPCodes in a given period for ECS Service"
  default     = "25"
}

variable "alb_target_group_alarms_5xx_threshold" {
  type        = "string"
  description = "The maximum number of 5XX HTTPCodes in a given period for ECS Service"
  default     = "25"
}

variable "alb_target_group_alarms_response_time_threshold" {
  type        = "string"
  description = "The maximum ALB Target Group response time"
  default     = "0.5"
}

variable "alb_target_group_alarms_period" {
  type        = "string"
  description = "The period (in seconds) to analyze for ALB CloudWatch Alarms"
  default     = "300"
}

variable "alb_target_group_alarms_evaluation_periods" {
  type        = "string"
  description = "The number of periods to analyze for ALB CloudWatch Alarms"
  default     = "1"
}

variable "alb_target_group_alarms_alarm_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an ALARM state from any other state"
  default     = []
}

variable "alb_target_group_alarms_ok_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an OK state from any other state"
  default     = []
}

variable "alb_target_group_alarms_insufficient_data_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an INSUFFICIENT_DATA state from any other state"
  default     = []
}

variable "alb_name" {
  type        = "string"
  description = "Name of the ALB for the Target Group"
  default     = ""
}

variable "alb_arn_suffix" {
  type        = "string"
  description = "ARN suffix of the ALB for the Target Group"
  default     = ""
}

variable "alb_ingress_healthcheck_path" {
  type        = "string"
  description = "The path of the healthcheck which the ALB checks"
  default     = "/"
}

variable "alb_ingress_listener_unauthenticated_priority" {
  type        = "string"
  default     = "1000"
  description = "The priority for the rules without authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_authenticated_priority` since a listener can't have multiple rules with the same priority"
}

variable "alb_ingress_listener_authenticated_priority" {
  type        = "string"
  default     = "300"
  description = "The priority for the rules with authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_unauthenticated_priority` since a listener can't have multiple rules with the same priority"
}

variable "alb_ingress_unauthenticated_hosts" {
  type        = "list"
  default     = []
  description = "Unauthenticated hosts to match in Hosts header"
}

variable "alb_ingress_authenticated_hosts" {
  type        = "list"
  default     = []
  description = "Authenticated hosts to match in Hosts header"
}

variable "alb_ingress_unauthenticated_paths" {
  type        = "list"
  default     = []
  description = "Unauthenticated path pattern to match (a maximum of 1 can be defined)"
}

variable "alb_ingress_authenticated_paths" {
  type        = "list"
  default     = []
  description = "Authenticated path pattern to match (a maximum of 1 can be defined)"
}

variable "vpc_id" {
  type        = "string"
  description = "The VPC ID where resources are created"
}

variable "aws_logs_region" {
  type        = "string"
  description = "The region for the AWS Cloudwatch Logs group"
}

variable "ecs_alarms_enabled" {
  type        = "string"
  description = "A boolean to enable/disable CloudWatch Alarms for ECS Service metrics"
  default     = "false"
}

variable "ecs_cluster_arn" {
  type        = "string"
  description = "The ECS Cluster ARN where ECS Service will be provisioned"
}

variable "ecs_cluster_name" {
  type        = "string"
  description = "The ECS Cluster Name to use in ECS Code Pipeline Deployment step"
}

variable "ecs_alarms_cpu_utilization_high_threshold" {
  type        = "string"
  description = "The maximum percentage of CPU utilization average"
  default     = "80"
}

variable "ecs_alarms_cpu_utilization_high_evaluation_periods" {
  type        = "string"
  description = "Number of periods to evaluate for the alarm"
  default     = "1"
}

variable "ecs_alarms_cpu_utilization_high_period" {
  type        = "string"
  description = "Duration in seconds to evaluate for the alarm"
  default     = "300"
}

variable "ecs_alarms_cpu_utilization_high_alarm_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High Alarm action"
  default     = []
}

variable "ecs_alarms_cpu_utilization_high_ok_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High OK action"
  default     = []
}

variable "ecs_alarms_cpu_utilization_low_threshold" {
  type        = "string"
  description = "The minimum percentage of CPU utilization average"
  default     = "20"
}

variable "ecs_alarms_cpu_utilization_low_evaluation_periods" {
  type        = "string"
  description = "Number of periods to evaluate for the alarm"
  default     = "1"
}

variable "ecs_alarms_cpu_utilization_low_period" {
  type        = "string"
  description = "Duration in seconds to evaluate for the alarm"
  default     = "300"
}

variable "ecs_alarms_cpu_utilization_low_alarm_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low Alarm action"
  default     = []
}

variable "ecs_alarms_cpu_utilization_low_ok_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low OK action"
  default     = []
}

variable "ecs_alarms_memory_utilization_high_threshold" {
  type        = "string"
  description = "The maximum percentage of Memory utilization average"
  default     = "80"
}

variable "ecs_alarms_memory_utilization_high_evaluation_periods" {
  type        = "string"
  description = "Number of periods to evaluate for the alarm"
  default     = "1"
}

variable "ecs_alarms_memory_utilization_high_period" {
  type        = "string"
  description = "Duration in seconds to evaluate for the alarm"
  default     = "300"
}

variable "ecs_alarms_memory_utilization_high_alarm_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High Alarm action"
  default     = []
}

variable "ecs_alarms_memory_utilization_high_ok_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High OK action"
  default     = []
}

variable "ecs_alarms_memory_utilization_low_threshold" {
  type        = "string"
  description = "The minimum percentage of Memory utilization average"
  default     = "20"
}

variable "ecs_alarms_memory_utilization_low_evaluation_periods" {
  type        = "string"
  description = "Number of periods to evaluate for the alarm"
  default     = "1"
}

variable "ecs_alarms_memory_utilization_low_period" {
  type        = "string"
  description = "Duration in seconds to evaluate for the alarm"
  default     = "300"
}

variable "ecs_alarms_memory_utilization_low_alarm_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low Alarm action"
  default     = []
}

variable "ecs_alarms_memory_utilization_low_ok_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low OK action"
  default     = []
}

variable "ecs_security_group_ids" {
  type        = "list"
  description = "Additional Security Group IDs to allow into ECS Service"
  default     = []
}

variable "ecs_private_subnet_ids" {
  type        = "list"
  description = "List of Private Subnet IDs to provision ECS Service onto"
}

variable "github_oauth_token" {
  type        = "string"
  description = "GitHub Oauth Token with permissions to access private repositories"
  default     = ""
}

variable "github_webhook_events" {
  type        = "list"
  description = "A list of events which should trigger the webhook. See a list of [available events](https://developer.github.com/v3/activity/events/types/)"
  default     = ["push"]
}

variable "repo_owner" {
  type        = "string"
  description = "GitHub Organization or Username"
  default     = ""
}

variable "repo_name" {
  type        = "string"
  description = "GitHub repository name of the application to be built and deployed to ECS"
  default     = ""
}

variable "branch" {
  type        = "string"
  description = "Branch of the GitHub repository, e.g. master"
  default     = ""
}

variable "badge_enabled" {
  type        = "string"
  default     = "false"
  description = "Generates a publicly-accessible URL for the projects build badge. Available as badge_url attribute when enabled"
}

variable "build_image" {
  default     = "aws/codebuild/docker:17.09.0"
  description = "Docker image for build environment, _e.g._ `aws/codebuild/docker:docker:17.09.0`"
}

variable "build_timeout" {
  type        = "string"
  default     = "60"
  description = "How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed"
}

variable "buildspec" {
  default     = ""
  description = "Declaration to use for building the project. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html)"
}

variable "autoscaling_enabled" {
  type        = "string"
  description = "A boolean to enable/disable Autoscaling policy for ECS Service"
  default     = "false"
}

variable "autoscaling_dimension" {
  type        = "string"
  description = "Dimension to autoscale on (valid options: cpu, memory)"
  default     = "memory"
}

variable "autoscaling_min_capacity" {
  type        = "string"
  description = "Minimum number of running instances of a Service"
  default     = "1"
}

variable "autoscaling_max_capacity" {
  type        = "string"
  description = "Maximum number of running instances of a Service"
  default     = "2"
}

variable "autoscaling_scale_up_adjustment" {
  type        = "string"
  description = "Scaling adjustment to make during scale up event"
  default     = "1"
}

variable "autoscaling_scale_up_cooldown" {
  type        = "string"
  description = "Period (in seconds) to wait between scale up events"
  default     = "60"
}

variable "autoscaling_scale_down_adjustment" {
  type        = "string"
  description = "Scaling adjustment to make during scale down event"
  default     = "-1"
}

variable "autoscaling_scale_down_cooldown" {
  type        = "string"
  description = "Period (in seconds) to wait between scale down events"
  default     = "300"
}

# https://www.terraform.io/docs/configuration/variables.html
# It is recommended you avoid using boolean values and use explicit strings
variable "poll_source_changes" {
  type        = "string"
  default     = "false"
  description = "Periodically check the location of your source content and run the pipeline if changes are detected"
}

variable "webhook_enabled" {
  description = "Set to false to prevent the module from creating any webhook resources"
  default     = "true"
}

variable "webhook_target_action" {
  description = "The name of the action in a pipeline you want to connect to the webhook. The action must be from the source (first) stage of the pipeline"
  default     = "Source"
}

variable "webhook_authentication" {
  description = "The type of authentication to use. One of IP, GITHUB_HMAC, or UNAUTHENTICATED"
  default     = "GITHUB_HMAC"
}

variable "webhook_filter_json_path" {
  description = "The JSON path to filter on"
  default     = "$.ref"
}

variable "webhook_filter_match_equals" {
  description = "The value to match on (e.g. refs/heads/{Branch})"
  default     = "refs/heads/{Branch}"
}

variable "alb_ingress_unauthenticated_listener_arns" {
  type        = "list"
  default     = []
  description = "A list of unauthenticated ALB listener ARNs to attach ALB listener rules to"
}

variable "alb_ingress_unauthenticated_listener_arns_count" {
  type        = "string"
  default     = "0"
  description = "The number of unauthenticated ARNs in `alb_ingress_unauthenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed"
}

variable "alb_ingress_authenticated_listener_arns" {
  type        = "list"
  default     = []
  description = "A list of authenticated ALB listener ARNs to attach ALB listener rules to"
}

variable "alb_ingress_authenticated_listener_arns_count" {
  type        = "string"
  default     = "0"
  description = "The number of authenticated ARNs in `alb_ingress_authenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed"
}

variable "authentication_type" {
  type        = "string"
  default     = ""
  description = "Authentication type. Supported values are `COGNITO` and `OIDC`"
}

variable "authentication_cognito_user_pool_arn" {
  type        = "string"
  description = "Cognito User Pool ARN"
  default     = ""
}

variable "authentication_cognito_user_pool_client_id" {
  type        = "string"
  description = "Cognito User Pool Client ID"
  default     = ""
}

variable "authentication_cognito_user_pool_domain" {
  type        = "string"
  description = "Cognito User Pool Domain. The User Pool Domain should be set to the domain prefix (`xxx`) instead of full domain (https://xxx.auth.us-west-2.amazoncognito.com)"
  default     = ""
}

variable "authentication_oidc_client_id" {
  type        = "string"
  description = "OIDC Client ID"
  default     = ""
}

variable "authentication_oidc_client_secret" {
  type        = "string"
  description = "OIDC Client Secret"
  default     = ""
}

variable "authentication_oidc_issuer" {
  type        = "string"
  description = "OIDC Issuer"
  default     = ""
}

variable "authentication_oidc_authorization_endpoint" {
  type        = "string"
  description = "OIDC Authorization Endpoint"
  default     = ""
}

variable "authentication_oidc_token_endpoint" {
  type        = "string"
  description = "OIDC Token Endpoint"
  default     = ""
}

variable "authentication_oidc_user_info_endpoint" {
  type        = "string"
  description = "OIDC User Info Endpoint"
  default     = ""
}

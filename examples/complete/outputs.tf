output "public_subnet_cidrs" {
  value       = module.subnets.public_subnet_cidrs
  description = "Public subnet CIDRs"
}

output "private_subnet_cidrs" {
  value       = module.subnets.private_subnet_cidrs
  description = "Private subnet CIDRs"
}

output "vpc_cidr" {
  value       = module.vpc.vpc_cidr_block
  description = "VPC ID"
}

output "alb_name" {
  description = "The ARN suffix of the ALB"
  value       = module.alb.alb_name
}

output "alb_arn" {
  description = "The ARN of the ALB"
  value       = module.alb.alb_arn
}

output "alb_arn_suffix" {
  description = "The ARN suffix of the ALB"
  value       = module.alb.alb_arn_suffix
}

output "alb_dns_name" {
  description = "DNS name of ALB"
  value       = module.alb.alb_dns_name
}

output "alb_zone_id" {
  description = "The ID of the zone which ALB is provisioned"
  value       = module.alb.alb_zone_id
}

output "alb_security_group_id" {
  description = "The security group ID of the ALB"
  value       = module.alb.security_group_id
}

output "alb_default_target_group_arn" {
  description = "The default target group ARN"
  value       = module.alb.default_target_group_arn
}

output "alb_http_listener_arn" {
  description = "The ARN of the HTTP listener"
  value       = module.alb.http_listener_arn
}

output "alb_listener_arns" {
  description = "A list of all the listener ARNs"
  value       = module.alb.listener_arns
}

output "alb_access_logs_bucket_id" {
  description = "The S3 bucket ID for access logs"
  value       = module.alb.access_logs_bucket_id
}

output "ecr_registry_id" {
  value       = module.ecs_web_app.ecr_registry_id
  description = "Registry ID"
}

output "ecr_repository_url" {
  value       = module.ecs_web_app.ecr_repository_url
  description = "Repository URL"
}

output "ecr_repository_name" {
  value       = module.ecs_web_app.ecr_repository_name
  description = "Registry name"
}

output "alb_ingress_target_group_name" {
  description = "ALB Target Group name"
  value       = module.ecs_web_app.alb_ingress_target_group_name
}

output "alb_ingress_target_group_arn" {
  description = "ALB Target Group ARN"
  value       = module.ecs_web_app.alb_ingress_target_group_arn
}

output "alb_ingress_target_group_arn_suffix" {
  description = "ALB Target Group ARN suffix"
  value       = module.ecs_web_app.alb_ingress_target_group_arn_suffix
}

output "container_definition_json" {
  description = "JSON encoded list of container definitions for use with other terraform resources such as aws_ecs_task_definition"
  value       = module.ecs_web_app.container_definition_json
}

output "container_definition_json_map" {
  description = "JSON encoded container definitions for use with other terraform resources such as aws_ecs_task_definition"
  value       = module.ecs_web_app.container_definition_json_map
}

output "ecs_exec_role_policy_id" {
  description = "The ECS service role policy ID, in the form of `role_name:role_policy_name`"
  value       = module.ecs_web_app.ecs_exec_role_policy_id
}

output "ecs_exec_role_policy_name" {
  description = "ECS service role name"
  value       = module.ecs_web_app.ecs_exec_role_policy_name
}

output "ecs_service_name" {
  description = "ECS Service name"
  value       = module.ecs_web_app.ecs_service_name
}

output "ecs_service_role_arn" {
  description = "ECS Service role ARN"
  value       = module.ecs_web_app.ecs_service_role_arn
}

output "ecs_task_exec_role_name" {
  description = "ECS Task role name"
  value       = module.ecs_web_app.ecs_task_exec_role_name
}

output "ecs_task_exec_role_arn" {
  description = "ECS Task exec role ARN"
  value       = module.ecs_web_app.ecs_task_exec_role_arn
}

output "ecs_task_role_name" {
  description = "ECS Task role name"
  value       = module.ecs_web_app.ecs_task_role_name
}

output "ecs_task_role_arn" {
  description = "ECS Task role ARN"
  value       = module.ecs_web_app.ecs_task_role_arn
}

output "ecs_task_role_id" {
  description = "ECS Task role id"
  value       = module.ecs_web_app.ecs_task_role_id
}

output "ecs_service_security_group_id" {
  description = "Security Group ID of the ECS task"
  value       = module.ecs_web_app.ecs_service_security_group_id
}

output "ecs_task_definition_family" {
  description = "ECS task definition family"
  value       = module.ecs_web_app.ecs_task_definition_family
}

output "ecs_task_definition_revision" {
  description = "ECS task definition revision"
  value       = module.ecs_web_app.ecs_task_definition_revision
}

output "codebuild_project_name" {
  description = "CodeBuild project name"
  value       = module.ecs_web_app.codebuild_project_name
}

output "codebuild_project_id" {
  description = "CodeBuild project ID"
  value       = module.ecs_web_app.codebuild_project_id
}

output "codebuild_role_id" {
  description = "CodeBuild IAM Role ID"
  value       = module.ecs_web_app.codebuild_role_id
}

output "codebuild_role_arn" {
  description = "CodeBuild IAM Role ARN"
  value       = module.ecs_web_app.codebuild_role_arn
}

output "codebuild_cache_bucket_name" {
  description = "CodeBuild cache S3 bucket name"
  value       = module.ecs_web_app.codebuild_cache_bucket_name
}

output "codebuild_cache_bucket_arn" {
  description = "CodeBuild cache S3 bucket ARN"
  value       = module.ecs_web_app.codebuild_cache_bucket_arn
}

output "codebuild_badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = module.ecs_web_app.codebuild_badge_url
}

output "codepipeline_id" {
  description = "CodePipeline ID"
  value       = module.ecs_web_app.codepipeline_id
}

output "codepipeline_arn" {
  description = "CodePipeline ARN"
  value       = module.ecs_web_app.codepipeline_arn
}

output "codepipeline_webhook_id" {
  description = "The CodePipeline webhook's ID"
  value       = module.ecs_web_app.codepipeline_webhook_id
}

output "codepipeline_webhook_url" {
  description = "The CodePipeline webhook's URL. POST events to this endpoint to trigger the target"
  value       = module.ecs_web_app.codepipeline_webhook_url
  sensitive   = true
}

output "ecs_cloudwatch_autoscaling_scale_up_policy_arn" {
  description = "ARN of the scale up policy"
  value       = module.ecs_web_app.ecs_cloudwatch_autoscaling_scale_up_policy_arn
}

output "ecs_cloudwatch_autoscaling_scale_down_policy_arn" {
  description = "ARN of the scale down policy"
  value       = module.ecs_web_app.ecs_cloudwatch_autoscaling_scale_down_policy_arn
}

output "ecs_alarms_cpu_utilization_high_cloudwatch_metric_alarm_id" {
  value       = module.ecs_web_app.ecs_alarms_cpu_utilization_high_cloudwatch_metric_alarm_id
  description = "ECS CPU utilization high CloudWatch metric alarm ID"
}

output "ecs_alarms_cpu_utilization_high_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_web_app.ecs_alarms_cpu_utilization_high_cloudwatch_metric_alarm_arn
  description = "ECS CPU utilization high CloudWatch metric alarm ARN"
}

output "ecs_alarms_cpu_utilization_low_cloudwatch_metric_alarm_id" {
  value       = module.ecs_web_app.ecs_alarms_cpu_utilization_low_cloudwatch_metric_alarm_id
  description = "ECS CPU utilization low CloudWatch metric alarm ID"
}

output "ecs_alarms_cpu_utilization_low_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_web_app.ecs_alarms_cpu_utilization_low_cloudwatch_metric_alarm_arn
  description = "ECS CPU utilization low CloudWatch metric alarm ARN"
}

output "ecs_alarms_memory_utilization_high_cloudwatch_metric_alarm_id" {
  value       = module.ecs_web_app.ecs_alarms_memory_utilization_high_cloudwatch_metric_alarm_id
  description = "ECS Memory utilization high CloudWatch metric alarm ID"
}

output "ecs_alarms_memory_utilization_high_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_web_app.ecs_alarms_memory_utilization_high_cloudwatch_metric_alarm_arn
  description = "ECS Memory utilization high CloudWatch metric alarm ARN"
}

output "ecs_alarms_memory_utilization_low_cloudwatch_metric_alarm_id" {
  value       = module.ecs_web_app.ecs_alarms_memory_utilization_low_cloudwatch_metric_alarm_id
  description = "ECS Memory utilization low CloudWatch metric alarm ID"
}

output "ecs_alarms_memory_utilization_low_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_web_app.ecs_alarms_memory_utilization_low_cloudwatch_metric_alarm_arn
  description = "ECS Memory utilization low CloudWatch metric alarm ARN"
}

output "httpcode_target_3xx_count_cloudwatch_metric_alarm_id" {
  value       = module.ecs_web_app.httpcode_target_3xx_count_cloudwatch_metric_alarm_id
  description = "ALB Target Group 3xx count CloudWatch metric alarm ID"
}

output "httpcode_target_3xx_count_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_web_app.httpcode_target_3xx_count_cloudwatch_metric_alarm_arn
  description = "ALB Target Group 3xx count CloudWatch metric alarm ARN"
}

output "httpcode_target_4xx_count_cloudwatch_metric_alarm_id" {
  value       = module.ecs_web_app.httpcode_target_4xx_count_cloudwatch_metric_alarm_id
  description = "ALB Target Group 4xx count CloudWatch metric alarm ID"
}

output "httpcode_target_4xx_count_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_web_app.httpcode_target_4xx_count_cloudwatch_metric_alarm_arn
  description = "ALB Target Group 4xx count CloudWatch metric alarm ARN"
}

output "httpcode_target_5xx_count_cloudwatch_metric_alarm_id" {
  value       = module.ecs_web_app.httpcode_target_5xx_count_cloudwatch_metric_alarm_id
  description = "ALB Target Group 5xx count CloudWatch metric alarm ID"
}

output "httpcode_target_5xx_count_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_web_app.httpcode_target_5xx_count_cloudwatch_metric_alarm_arn
  description = "ALB Target Group 5xx count CloudWatch metric alarm ARN"
}

output "httpcode_elb_5xx_count_cloudwatch_metric_alarm_id" {
  value       = module.ecs_web_app.httpcode_elb_5xx_count_cloudwatch_metric_alarm_id
  description = "ALB 5xx count CloudWatch metric alarm ID"
}

output "httpcode_elb_5xx_count_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_web_app.httpcode_elb_5xx_count_cloudwatch_metric_alarm_arn
  description = "ALB 5xx count CloudWatch metric alarm ARN"
}

output "target_response_time_average_cloudwatch_metric_alarm_id" {
  value       = module.ecs_web_app.target_response_time_average_cloudwatch_metric_alarm_id
  description = "ALB Target Group response time average CloudWatch metric alarm ID"
}

output "target_response_time_average_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_web_app.target_response_time_average_cloudwatch_metric_alarm_arn
  description = "ALB Target Group response time average CloudWatch metric alarm ARN"
}

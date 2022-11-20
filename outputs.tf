output "ecr" {
  value       = module.ecr
  description = "All outputs from `module.ecr`"
}

output "ecr_registry_id" {
  value       = module.ecr.registry_id
  description = "Registry ID"
}

output "ecr_registry_url" {
  value       = module.ecr.repository_url
  description = "Repository URL"
}

output "ecr_repository_url" {
  value       = module.ecr.repository_url
  description = "Repository URL"
}

output "ecr_repository_name" {
  value       = module.ecr.repository_name
  description = "Registry name"
}

output "ecr_repository_arn" {
  value       = module.ecr.repository_arn
  description = "ARN of ECR repository"
}

output "alb_ingress" {
  description = "All outputs from `module.alb_ingress`"
  value       = module.alb_ingress
}

output "alb_ingress_target_group_name" {
  description = "ALB Target Group name"
  value       = module.alb_ingress.target_group_name
}

output "alb_ingress_target_group_arn" {
  description = "ALB Target Group ARN"
  value       = module.alb_ingress.target_group_arn
}

output "alb_ingress_target_group_arn_suffix" {
  description = "ALB Target Group ARN suffix"
  value       = module.alb_ingress.target_group_arn_suffix
}

output "container_definition" {
  description = "All outputs from `module.container_definition`"
  value       = module.container_definition
  sensitive   = true
}

output "container_definition_json" {
  description = "JSON encoded list of container definitions for use with other terraform resources such as aws_ecs_task_definition"
  value       = module.container_definition.json_map_encoded_list
  sensitive   = true
}

output "container_definition_json_map" {
  description = "JSON encoded container definitions for use with other terraform resources such as aws_ecs_task_definition"
  value       = module.container_definition.json_map_encoded
  sensitive   = true
}

output "ecs_alb_service_task" {
  description = "All outputs from `module.ecs_alb_service_task`"
  value       = module.ecs_alb_service_task
}

output "ecs_exec_role_policy_id" {
  description = "The ECS service role policy ID, in the form of `role_name:role_policy_name`"
  value       = module.ecs_alb_service_task.ecs_exec_role_policy_id
}

output "ecs_exec_role_policy_name" {
  description = "ECS service role name"
  value       = module.ecs_alb_service_task.ecs_exec_role_policy_name
}

output "ecs_service_arn" {
  description = "ECS Service ARN"
  value       = module.ecs_alb_service_task.service_arn
}

output "ecs_service_name" {
  description = "ECS Service name"
  value       = module.ecs_alb_service_task.service_name
}

output "ecs_service_role_arn" {
  description = "ECS Service role ARN"
  value       = module.ecs_alb_service_task.service_role_arn
}

output "ecs_task_exec_role_name" {
  description = "ECS Task role name"
  value       = module.ecs_alb_service_task.task_exec_role_name
}

output "ecs_task_exec_role_arn" {
  description = "ECS Task exec role ARN"
  value       = module.ecs_alb_service_task.task_exec_role_arn
}

output "ecs_task_role_name" {
  description = "ECS Task role name"
  value       = module.ecs_alb_service_task.task_role_name
}

output "ecs_task_role_arn" {
  description = "ECS Task role ARN"
  value       = module.ecs_alb_service_task.task_role_arn
}

output "ecs_task_role_id" {
  description = "ECS Task role id"
  value       = module.ecs_alb_service_task.task_role_id
}

output "ecs_service_security_group_id" {
  description = "Security Group ID of the ECS task"
  value       = module.ecs_alb_service_task.service_security_group_id
}

output "ecs_task_definition_family" {
  description = "ECS task definition family"
  value       = module.ecs_alb_service_task.task_definition_family
}

output "ecs_task_definition_revision" {
  description = "ECS task definition revision"
  value       = module.ecs_alb_service_task.task_definition_revision
}

output "cloudwatch_log_group" {
  description = "All outputs from `aws_cloudwatch_log_group.app`"
  value       = aws_cloudwatch_log_group.app
}

output "cloudwatch_log_group_arn" {
  description = "Cloudwatch log group ARN"
  value       = join("", aws_cloudwatch_log_group.app.*.arn)
}

output "cloudwatch_log_group_name" {
  description = "Cloudwatch log group name"
  value       = join("", aws_cloudwatch_log_group.app.*.name)
}

output "codebuild" {
  description = "All outputs from `module.ecs_codepipeline`"
  value       = module.ecs_codepipeline
  sensitive   = true
}

output "codebuild_project_name" {
  description = "CodeBuild project name"
  value       = module.ecs_codepipeline.codebuild_project_name
}

output "codebuild_project_id" {
  description = "CodeBuild project ID"
  value       = module.ecs_codepipeline.codebuild_project_id
}

output "codebuild_role_id" {
  description = "CodeBuild IAM Role ID"
  value       = module.ecs_codepipeline.codebuild_role_id
}

output "codebuild_role_arn" {
  description = "CodeBuild IAM Role ARN"
  value       = module.ecs_codepipeline.codebuild_role_arn
}

output "codebuild_cache_bucket_name" {
  description = "CodeBuild cache S3 bucket name"
  value       = module.ecs_codepipeline.codebuild_cache_bucket_name
}

output "codebuild_cache_bucket_arn" {
  description = "CodeBuild cache S3 bucket ARN"
  value       = module.ecs_codepipeline.codebuild_cache_bucket_arn
}

output "codebuild_badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = module.ecs_codepipeline.codebuild_badge_url
}

output "codepipeline_id" {
  description = "CodePipeline ID"
  value       = module.ecs_codepipeline.codepipeline_id
}

output "codepipeline_arn" {
  description = "CodePipeline ARN"
  value       = module.ecs_codepipeline.codepipeline_arn
}

output "codepipeline_webhook_id" {
  description = "The CodePipeline webhook's ID"
  value       = module.ecs_codepipeline.webhook_id
}

output "codepipeline_webhook_url" {
  description = "The CodePipeline webhook's URL. POST events to this endpoint to trigger the target"
  value       = module.ecs_codepipeline.webhook_url
  sensitive   = true
}

output "ecs_cloudwatch_autoscaling" {
  description = "All outputs from `module.ecs_cloudwatch_autoscaling`"
  value       = module.ecs_cloudwatch_autoscaling
}

output "ecs_cloudwatch_autoscaling_scale_up_policy_arn" {
  description = "ARN of the scale up policy"
  value       = module.ecs_cloudwatch_autoscaling.scale_up_policy_arn
}

output "ecs_cloudwatch_autoscaling_scale_down_policy_arn" {
  description = "ARN of the scale down policy"
  value       = module.ecs_cloudwatch_autoscaling.scale_down_policy_arn
}

output "ecs_alarms" {
  description = "All outputs from `module.ecs_cloudwatch_sns_alarms`"
  value       = module.ecs_cloudwatch_sns_alarms
}

output "ecs_alarms_cpu_utilization_high_cloudwatch_metric_alarm_id" {
  value       = module.ecs_cloudwatch_sns_alarms.cpu_utilization_high_cloudwatch_metric_alarm_id
  description = "ECS CPU utilization high CloudWatch metric alarm ID"
}

output "ecs_alarms_cpu_utilization_high_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_cloudwatch_sns_alarms.cpu_utilization_high_cloudwatch_metric_alarm_arn
  description = "ECS CPU utilization high CloudWatch metric alarm ARN"
}

output "ecs_alarms_cpu_utilization_low_cloudwatch_metric_alarm_id" {
  value       = module.ecs_cloudwatch_sns_alarms.cpu_utilization_low_cloudwatch_metric_alarm_id
  description = "ECS CPU utilization low CloudWatch metric alarm ID"
}

output "ecs_alarms_cpu_utilization_low_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_cloudwatch_sns_alarms.cpu_utilization_low_cloudwatch_metric_alarm_arn
  description = "ECS CPU utilization low CloudWatch metric alarm ARN"
}

output "ecs_alarms_memory_utilization_high_cloudwatch_metric_alarm_id" {
  value       = module.ecs_cloudwatch_sns_alarms.memory_utilization_high_cloudwatch_metric_alarm_id
  description = "ECS Memory utilization high CloudWatch metric alarm ID"
}

output "ecs_alarms_memory_utilization_high_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_cloudwatch_sns_alarms.memory_utilization_high_cloudwatch_metric_alarm_arn
  description = "ECS Memory utilization high CloudWatch metric alarm ARN"
}

output "ecs_alarms_memory_utilization_low_cloudwatch_metric_alarm_id" {
  value       = module.ecs_cloudwatch_sns_alarms.memory_utilization_low_cloudwatch_metric_alarm_id
  description = "ECS Memory utilization low CloudWatch metric alarm ID"
}

output "ecs_alarms_memory_utilization_low_cloudwatch_metric_alarm_arn" {
  value       = module.ecs_cloudwatch_sns_alarms.memory_utilization_low_cloudwatch_metric_alarm_arn
  description = "ECS Memory utilization low CloudWatch metric alarm ARN"
}

output "alb_target_group_cloudwatch_sns_alarms" {
  description = "All outputs from `module.alb_target_group_cloudwatch_sns_alarms`"
  value       = module.alb_target_group_cloudwatch_sns_alarms
}

output "httpcode_target_3xx_count_cloudwatch_metric_alarm_id" {
  value       = module.alb_target_group_cloudwatch_sns_alarms.httpcode_target_3xx_count_cloudwatch_metric_alarm_id
  description = "ALB Target Group 3xx count CloudWatch metric alarm ID"
}

output "httpcode_target_3xx_count_cloudwatch_metric_alarm_arn" {
  value       = module.alb_target_group_cloudwatch_sns_alarms.httpcode_target_3xx_count_cloudwatch_metric_alarm_arn
  description = "ALB Target Group 3xx count CloudWatch metric alarm ARN"
}

output "httpcode_target_4xx_count_cloudwatch_metric_alarm_id" {
  value       = module.alb_target_group_cloudwatch_sns_alarms.httpcode_target_4xx_count_cloudwatch_metric_alarm_id
  description = "ALB Target Group 4xx count CloudWatch metric alarm ID"
}

output "httpcode_target_4xx_count_cloudwatch_metric_alarm_arn" {
  value       = module.alb_target_group_cloudwatch_sns_alarms.httpcode_target_4xx_count_cloudwatch_metric_alarm_arn
  description = "ALB Target Group 4xx count CloudWatch metric alarm ARN"
}

output "httpcode_target_5xx_count_cloudwatch_metric_alarm_id" {
  value       = module.alb_target_group_cloudwatch_sns_alarms.httpcode_target_5xx_count_cloudwatch_metric_alarm_id
  description = "ALB Target Group 5xx count CloudWatch metric alarm ID"
}

output "httpcode_target_5xx_count_cloudwatch_metric_alarm_arn" {
  value       = module.alb_target_group_cloudwatch_sns_alarms.httpcode_target_5xx_count_cloudwatch_metric_alarm_arn
  description = "ALB Target Group 5xx count CloudWatch metric alarm ARN"
}

output "httpcode_elb_5xx_count_cloudwatch_metric_alarm_id" {
  value       = module.alb_target_group_cloudwatch_sns_alarms.httpcode_elb_5xx_count_cloudwatch_metric_alarm_id
  description = "ALB 5xx count CloudWatch metric alarm ID"
}

output "httpcode_elb_5xx_count_cloudwatch_metric_alarm_arn" {
  value       = module.alb_target_group_cloudwatch_sns_alarms.httpcode_elb_5xx_count_cloudwatch_metric_alarm_arn
  description = "ALB 5xx count CloudWatch metric alarm ARN"
}

output "target_response_time_average_cloudwatch_metric_alarm_id" {
  value       = module.alb_target_group_cloudwatch_sns_alarms.target_response_time_average_cloudwatch_metric_alarm_id
  description = "ALB Target Group response time average CloudWatch metric alarm ID"
}

output "target_response_time_average_cloudwatch_metric_alarm_arn" {
  value       = module.alb_target_group_cloudwatch_sns_alarms.target_response_time_average_cloudwatch_metric_alarm_arn
  description = "ALB Target Group response time average CloudWatch metric alarm ARN"
}

output "scale_down_policy_arn" {
  description = "Autoscaling scale up policy ARN"
  value       = "${module.autoscaling.scale_down_policy_arn}"
}

output "scale_up_policy_arn" {
  description = "Autoscaling scale up policy ARN"
  value       = "${module.autoscaling.scale_up_policy_arn}"
}

output "service_name" {
  description = "ECS Service Name"
  value       = "${module.ecs_alb_service_task.service_name}"
}

output "task_role_name" {
  description = "ECS Task role name"
  value       = "${module.ecs_alb_service_task.task_role_name}"
}

output "task_role_arn" {
  description = "ECS Task role ARN"
  value       = "${module.ecs_alb_service_task.task_role_arn}"
}

output "service_security_group_id" {
  description = "Security Group id of the ECS task"
  value       = "${module.ecs_alb_service_task.service_security_group_id}"
}

output "badge_url" {
  description = "The URL of the build badge when badge_enabled is enabled"
  value       = "${module.ecs_pipeline.badge_url)}"
}

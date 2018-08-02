output "task_role_arn" {
  description = "ECS Task role ARN"
  value       = "${module.ecs_alb_service_task.task_role_arn}"
}

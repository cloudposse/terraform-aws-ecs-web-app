module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

module "ecr" {
  source     = "git::https://github.com/cloudposse/terraform-aws-ecr.git?ref=tags/0.7.0"
  enabled    = var.codepipeline_enabled
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  attributes = compact(concat(var.attributes, ["ecr"]))
}

resource "aws_cloudwatch_log_group" "app" {
  name              = module.default_label.id
  tags              = module.default_label.tags
  retention_in_days = var.log_retention_in_days
}

module "alb_ingress" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-alb-ingress.git?ref=tags/0.9.0"
  name                         = var.name
  namespace                    = var.namespace
  stage                        = var.stage
  attributes                   = var.attributes
  vpc_id                       = var.vpc_id
  port                         = var.container_port
  health_check_path            = var.alb_ingress_healthcheck_path
  default_target_group_enabled = true

  authenticated_paths   = var.alb_ingress_authenticated_paths
  unauthenticated_paths = var.alb_ingress_unauthenticated_paths
  authenticated_hosts   = var.alb_ingress_authenticated_hosts
  unauthenticated_hosts = var.alb_ingress_unauthenticated_hosts

  authenticated_priority   = var.alb_ingress_listener_authenticated_priority
  unauthenticated_priority = var.alb_ingress_listener_unauthenticated_priority

  unauthenticated_listener_arns       = var.alb_ingress_unauthenticated_listener_arns
  unauthenticated_listener_arns_count = var.alb_ingress_unauthenticated_listener_arns_count
  authenticated_listener_arns         = var.alb_ingress_authenticated_listener_arns
  authenticated_listener_arns_count   = var.alb_ingress_authenticated_listener_arns_count

  authentication_type                        = var.authentication_type
  authentication_cognito_user_pool_arn       = var.authentication_cognito_user_pool_arn
  authentication_cognito_user_pool_client_id = var.authentication_cognito_user_pool_client_id
  authentication_cognito_user_pool_domain    = var.authentication_cognito_user_pool_domain
  authentication_oidc_client_id              = var.authentication_oidc_client_id
  authentication_oidc_client_secret          = var.authentication_oidc_client_secret
  authentication_oidc_issuer                 = var.authentication_oidc_issuer
  authentication_oidc_authorization_endpoint = var.authentication_oidc_authorization_endpoint
  authentication_oidc_token_endpoint         = var.authentication_oidc_token_endpoint
  authentication_oidc_user_info_endpoint     = var.authentication_oidc_user_info_endpoint
}

module "container_definition" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.22.0"
  container_name               = module.default_label.id
  container_image              = var.container_image
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_cpu
  healthcheck                  = var.healthcheck
  environment                  = var.environment
  port_mappings                = var.port_mappings
  secrets                      = var.secrets
  ulimits                      = var.ulimits
  entrypoint                   = var.entrypoint
  command                      = var.command
  mount_points                 = var.mount_points
  container_depends_on         = local.container_depends_on

  log_configuration = {
    logDriver = var.log_driver
    options = {
      "awslogs-region"        = var.aws_logs_region
      "awslogs-group"         = aws_cloudwatch_log_group.app.name
      "awslogs-stream-prefix" = var.name
    }
    secretOptions = null
  }
}

locals {
  alb = {
    container_name   = module.default_label.id
    container_port   = var.container_port
    elb_name         = null
    target_group_arn = module.alb_ingress.target_group_arn
  }
  nlb = {
    container_name   = module.default_label.id
    container_port   = var.nlb_container_port
    elb_name         = null
    target_group_arn = var.nlb_ingress_target_group_arn
  }
  load_balancers = var.nlb_ingress_target_group_arn != "" ? [local.alb, local.nlb] : [local.alb]
  init_container_definitions = [
    for init_container in var.init_containers : lookup(init_container, "container_definition")
  ]

  container_depends_on = [
    for init_container in var.init_containers :
    {
      containerName = lookup(jsondecode(init_container.container_definition), "name"),
      condition     = init_container.condition
    }
  ]
}

module "ecs_alb_service_task" {
  source                            = "git::https://github.com/cloudposse/terraform-aws-ecs-alb-service-task.git?ref=tags/0.21.0"
  name                              = var.name
  namespace                         = var.namespace
  stage                             = var.stage
  attributes                        = var.attributes
  alb_security_group                = var.alb_security_group
  use_alb_security_group            = var.use_alb_security_group
  nlb_cidr_blocks                   = var.nlb_cidr_blocks
  use_nlb_cidr_blocks               = var.use_nlb_cidr_blocks
  container_definition_json         = "[${join(",", concat(local.init_container_definitions, [module.container_definition.json_map]))}]"
  desired_count                     = var.desired_count
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  task_cpu                          = coalesce(var.task_cpu, var.container_cpu)
  task_memory                       = coalesce(var.task_memory, var.container_memory)
  ecs_cluster_arn                   = var.ecs_cluster_arn
  launch_type                       = var.launch_type
  vpc_id                            = var.vpc_id
  security_group_ids                = var.ecs_security_group_ids
  subnet_ids                        = var.ecs_private_subnet_ids
  container_port                    = var.container_port
  nlb_container_port                = var.nlb_container_port
  tags                              = var.tags
  volumes                           = var.volumes
  ecs_load_balancers                = local.load_balancers
}

module "ecs_codepipeline" {
  enabled               = var.codepipeline_enabled
  source                = "git::https://github.com/cloudposse/terraform-aws-ecs-codepipeline.git?ref=tags/0.10.0"
  name                  = var.name
  namespace             = var.namespace
  stage                 = var.stage
  attributes            = var.attributes
  region                = var.region
  github_oauth_token    = var.github_oauth_token
  github_webhooks_token = var.github_webhooks_token
  github_webhook_events = var.github_webhook_events
  repo_owner            = var.repo_owner
  repo_name             = var.repo_name
  branch                = var.branch
  badge_enabled         = var.badge_enabled
  build_image           = var.build_image
  build_timeout         = var.build_timeout
  buildspec             = var.buildspec
  image_repo_name       = module.ecr.repository_name
  service_name          = module.ecs_alb_service_task.service_name
  ecs_cluster_name      = var.ecs_cluster_name
  privileged_mode       = true
  poll_source_changes   = var.poll_source_changes

  webhook_enabled             = var.webhook_enabled
  webhook_target_action       = var.webhook_target_action
  webhook_authentication      = var.webhook_authentication
  webhook_filter_json_path    = var.webhook_filter_json_path
  webhook_filter_match_equals = var.webhook_filter_match_equals

  s3_bucket_force_destroy = var.codepipeline_s3_bucket_force_destroy

  environment_variables = [
    {
      name  = "CONTAINER_NAME"
      value = module.default_label.id
    }
  ]
}

module "ecs_cloudwatch_autoscaling" {
  enabled               = var.autoscaling_enabled
  source                = "git::https://github.com/cloudposse/terraform-aws-ecs-cloudwatch-autoscaling.git?ref=tags/0.2.0"
  name                  = var.name
  namespace             = var.namespace
  stage                 = var.stage
  attributes            = var.attributes
  service_name          = module.ecs_alb_service_task.service_name
  cluster_name          = var.ecs_cluster_name
  min_capacity          = var.autoscaling_min_capacity
  max_capacity          = var.autoscaling_max_capacity
  scale_down_adjustment = var.autoscaling_scale_down_adjustment
  scale_down_cooldown   = var.autoscaling_scale_down_cooldown
  scale_up_adjustment   = var.autoscaling_scale_up_adjustment
  scale_up_cooldown     = var.autoscaling_scale_up_cooldown
}

locals {
  cpu_utilization_high_alarm_actions    = var.autoscaling_enabled && var.autoscaling_dimension == "cpu" ? module.ecs_cloudwatch_autoscaling.scale_up_policy_arn : ""
  cpu_utilization_low_alarm_actions     = var.autoscaling_enabled && var.autoscaling_dimension == "cpu" ? module.ecs_cloudwatch_autoscaling.scale_down_policy_arn : ""
  memory_utilization_high_alarm_actions = var.autoscaling_enabled && var.autoscaling_dimension == "memory" ? module.ecs_cloudwatch_autoscaling.scale_up_policy_arn : ""
  memory_utilization_low_alarm_actions  = var.autoscaling_enabled && var.autoscaling_dimension == "memory" ? module.ecs_cloudwatch_autoscaling.scale_down_policy_arn : ""
}

module "ecs_cloudwatch_sns_alarms" {
  source  = "git::https://github.com/cloudposse/terraform-aws-ecs-cloudwatch-sns-alarms.git?ref=tags/0.5.0"
  enabled = var.ecs_alarms_enabled

  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
  tags       = var.tags

  cluster_name = var.ecs_cluster_name
  service_name = module.ecs_alb_service_task.service_name

  cpu_utilization_high_threshold          = var.ecs_alarms_cpu_utilization_high_threshold
  cpu_utilization_high_evaluation_periods = var.ecs_alarms_cpu_utilization_high_evaluation_periods
  cpu_utilization_high_period             = var.ecs_alarms_cpu_utilization_high_period

  cpu_utilization_high_alarm_actions = compact(
    concat(
      var.ecs_alarms_cpu_utilization_high_alarm_actions,
      [local.cpu_utilization_high_alarm_actions],
    )
  )

  cpu_utilization_high_ok_actions = var.ecs_alarms_cpu_utilization_high_ok_actions

  cpu_utilization_low_threshold          = var.ecs_alarms_cpu_utilization_low_threshold
  cpu_utilization_low_evaluation_periods = var.ecs_alarms_cpu_utilization_low_evaluation_periods
  cpu_utilization_low_period             = var.ecs_alarms_cpu_utilization_low_period

  cpu_utilization_low_alarm_actions = compact(
    concat(
      var.ecs_alarms_cpu_utilization_low_alarm_actions,
      [local.cpu_utilization_low_alarm_actions],
    )
  )

  cpu_utilization_low_ok_actions = var.ecs_alarms_cpu_utilization_low_ok_actions

  memory_utilization_high_threshold          = var.ecs_alarms_memory_utilization_high_threshold
  memory_utilization_high_evaluation_periods = var.ecs_alarms_memory_utilization_high_evaluation_periods
  memory_utilization_high_period             = var.ecs_alarms_memory_utilization_high_period

  memory_utilization_high_alarm_actions = compact(
    concat(
      var.ecs_alarms_memory_utilization_high_alarm_actions,
      [local.memory_utilization_high_alarm_actions],
    )
  )

  memory_utilization_high_ok_actions = var.ecs_alarms_memory_utilization_high_ok_actions

  memory_utilization_low_threshold          = var.ecs_alarms_memory_utilization_low_threshold
  memory_utilization_low_evaluation_periods = var.ecs_alarms_memory_utilization_low_evaluation_periods
  memory_utilization_low_period             = var.ecs_alarms_memory_utilization_low_period

  memory_utilization_low_alarm_actions = compact(
    concat(
      var.ecs_alarms_memory_utilization_low_alarm_actions,
      [local.memory_utilization_low_alarm_actions],
    )
  )

  memory_utilization_low_ok_actions = var.ecs_alarms_memory_utilization_low_ok_actions
}

module "alb_target_group_cloudwatch_sns_alarms" {
  source                         = "git::https://github.com/cloudposse/terraform-aws-alb-target-group-cloudwatch-sns-alarms.git?ref=tags/0.7.0"
  enabled                        = var.alb_target_group_alarms_enabled
  name                           = var.name
  namespace                      = var.namespace
  stage                          = var.stage
  attributes                     = var.attributes
  alarm_actions                  = var.alb_target_group_alarms_alarm_actions
  ok_actions                     = var.alb_target_group_alarms_ok_actions
  insufficient_data_actions      = var.alb_target_group_alarms_insufficient_data_actions
  alb_arn_suffix                 = var.alb_arn_suffix
  target_group_arn_suffix        = module.alb_ingress.target_group_arn_suffix
  target_3xx_count_threshold     = var.alb_target_group_alarms_3xx_threshold
  target_4xx_count_threshold     = var.alb_target_group_alarms_4xx_threshold
  target_5xx_count_threshold     = var.alb_target_group_alarms_5xx_threshold
  target_response_time_threshold = var.alb_target_group_alarms_response_time_threshold
  period                         = var.alb_target_group_alarms_period
  evaluation_periods             = var.alb_target_group_alarms_evaluation_periods
}

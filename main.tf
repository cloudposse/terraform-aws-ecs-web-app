data "aws_region" "current" {}

module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "0.34.0"
  enabled = var.codepipeline_enabled

  attributes           = ["ecr"]
  scan_images_on_push  = var.ecr_scan_images_on_push
  image_tag_mutability = var.ecr_image_tag_mutability

  context = module.this.context
}

resource "aws_cloudwatch_log_group" "app" {
  count = var.cloudwatch_log_group_enabled ? 1 : 0

  name              = module.this.id
  tags              = module.this.tags
  retention_in_days = var.log_retention_in_days
}

module "alb_ingress" {
  source  = "cloudposse/alb-ingress/aws"
  version = "0.24.2"

  vpc_id                           = var.vpc_id
  port                             = var.container_port
  health_check_path                = var.alb_ingress_healthcheck_path
  health_check_protocol            = var.alb_ingress_healthcheck_protocol
  health_check_healthy_threshold   = var.alb_ingress_health_check_healthy_threshold
  health_check_interval            = var.alb_ingress_health_check_interval
  health_check_matcher             = var.alb_ingress_health_check_matcher
  health_check_timeout             = var.alb_ingress_health_check_timeout
  health_check_unhealthy_threshold = var.alb_ingress_health_check_unhealthy_threshold
  default_target_group_enabled     = var.alb_ingress_enable_default_target_group
  target_group_arn                 = var.alb_ingress_target_group_arn

  authenticated_paths   = var.alb_ingress_authenticated_paths
  unauthenticated_paths = var.alb_ingress_unauthenticated_paths
  authenticated_hosts   = var.alb_ingress_authenticated_hosts
  unauthenticated_hosts = var.alb_ingress_unauthenticated_hosts

  authenticated_priority   = var.alb_ingress_listener_authenticated_priority
  unauthenticated_priority = var.alb_ingress_listener_unauthenticated_priority

  unauthenticated_listener_arns = var.alb_ingress_unauthenticated_listener_arns
  authenticated_listener_arns   = var.alb_ingress_authenticated_listener_arns

  authentication_type                        = var.authentication_type
  authentication_cognito_user_pool_arn       = var.authentication_cognito_user_pool_arn
  authentication_cognito_user_pool_client_id = var.authentication_cognito_user_pool_client_id
  authentication_cognito_user_pool_domain    = var.authentication_cognito_user_pool_domain
  authentication_cognito_scope               = var.authentication_cognito_scope
  authentication_oidc_client_id              = var.authentication_oidc_client_id
  authentication_oidc_client_secret          = var.authentication_oidc_client_secret
  authentication_oidc_issuer                 = var.authentication_oidc_issuer
  authentication_oidc_authorization_endpoint = var.authentication_oidc_authorization_endpoint
  authentication_oidc_token_endpoint         = var.authentication_oidc_token_endpoint
  authentication_oidc_user_info_endpoint     = var.authentication_oidc_user_info_endpoint
  authentication_oidc_scope                  = var.authentication_oidc_scope

  stickiness_cookie_duration = var.alb_stickiness_cookie_duration
  stickiness_enabled         = var.alb_stickiness_enabled
  stickiness_type            = var.alb_stickiness_type

  context = module.this.context
}

module "container_definition" {
  source                       = "cloudposse/ecs-container-definition/aws"
  version                      = "0.58.1"
  container_name               = module.this.id
  container_image              = var.use_ecr_image ? module.ecr.repository_url : var.container_image
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_cpu
  start_timeout                = var.container_start_timeout
  stop_timeout                 = var.container_stop_timeout
  healthcheck                  = var.healthcheck
  environment                  = var.container_environment
  map_environment              = var.map_container_environment
  port_mappings                = var.port_mappings
  privileged                   = var.privileged
  secrets                      = var.secrets
  system_controls              = var.system_controls
  ulimits                      = var.ulimits
  entrypoint                   = var.entrypoint
  command                      = var.command
  mount_points                 = var.mount_points
  container_depends_on         = local.container_depends_on
  repository_credentials       = var.container_repo_credentials

  log_configuration = var.cloudwatch_log_group_enabled ? {
    logDriver = var.log_driver
    options = {
      "awslogs-region"        = coalesce(var.aws_logs_region, data.aws_region.current.name)
      "awslogs-group"         = join("", aws_cloudwatch_log_group.app.*.name)
      "awslogs-stream-prefix" = var.aws_logs_prefix == "" ? module.this.name : var.aws_logs_prefix
    }
    secretOptions = null
  } : null
}

locals {
  alb = {
    container_name   = coalesce(var.alb_container_name, module.this.id)
    container_port   = var.container_port
    elb_name         = null
    target_group_arn = module.alb_ingress.target_group_arn
  }
  nlb = {
    container_name   = coalesce(var.nlb_container_name, module.this.id)
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

  # override container_definition if var.container_definition is supplied
  main_container_definition = coalesce(var.container_definition, module.container_definition.json_map_encoded)
  # combine all container definitions
  all_container_definitions = "[${join(",", concat(local.init_container_definitions, [local.main_container_definition]))}]"
}

module "ecs_alb_service_task" {
  source  = "cloudposse/ecs-alb-service-task/aws"
  version = "0.64.1"

  alb_security_group                 = var.alb_security_group
  use_alb_security_group             = var.use_alb_security_group
  nlb_cidr_blocks                    = var.nlb_cidr_blocks
  use_nlb_cidr_blocks                = var.use_nlb_cidr_blocks
  container_definition_json          = local.all_container_definitions
  desired_count                      = var.desired_count
  ignore_changes_desired_count       = var.ignore_changes_desired_count
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  network_mode                       = var.network_mode
  task_cpu                           = coalesce(var.task_cpu, var.container_cpu)
  task_memory                        = coalesce(var.task_memory, var.container_memory)
  ignore_changes_task_definition     = var.ignore_changes_task_definition
  ecs_cluster_arn                    = var.ecs_cluster_arn
  capacity_provider_strategies       = var.capacity_provider_strategies
  service_registries                 = var.service_registries
  launch_type                        = var.launch_type
  enable_all_egress_rule             = var.enable_all_egress_rule
  platform_version                   = var.platform_version
  vpc_id                             = var.vpc_id
  assign_public_ip                   = var.assign_public_ip
  security_group_ids                 = var.ecs_security_group_ids
  subnet_ids                         = var.ecs_private_subnet_ids
  container_port                     = var.container_port
  nlb_container_port                 = var.nlb_container_port
  docker_volumes                     = var.volumes
  ecs_load_balancers                 = local.load_balancers
  deployment_controller_type         = var.deployment_controller_type
  force_new_deployment               = var.force_new_deployment
  exec_enabled                       = var.exec_enabled
  task_policy_arns                   = var.task_policy_arns
  task_role_arn                      = var.task_role_arn
  propagate_tags                     = var.propagate_tags
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  circuit_breaker_deployment_enabled = var.circuit_breaker_deployment_enabled
  circuit_breaker_rollback_enabled   = var.circuit_breaker_rollback_enabled
  permissions_boundary               = var.permissions_boundary
  runtime_platform                   = var.runtime_platform

  context = module.this.context
}

module "ecs_codepipeline" {
  enabled = var.codepipeline_enabled
  source  = "cloudposse/ecs-codepipeline/aws"
  version = "0.28.8"

  region                      = coalesce(var.region, data.aws_region.current.name)
  github_oauth_token          = var.github_oauth_token
  github_webhooks_token       = var.github_webhooks_token
  github_webhook_events       = var.github_webhook_events
  repo_owner                  = var.repo_owner
  repo_name                   = var.repo_name
  branch                      = var.branch
  badge_enabled               = var.badge_enabled
  build_image                 = var.build_image
  build_compute_type          = var.codepipeline_build_compute_type
  build_timeout               = var.build_timeout
  buildspec                   = var.buildspec
  cache_bucket_suffix_enabled = var.codepipeline_build_cache_bucket_suffix_enabled
  image_repo_name             = module.ecr.repository_name
  service_name                = module.ecs_alb_service_task.service_name
  ecs_cluster_name            = var.ecs_cluster_name
  privileged_mode             = true
  poll_source_changes         = var.poll_source_changes

  secondary_artifact_bucket_id          = var.codepipeline_cdn_bucket_id
  secondary_artifact_encryption_enabled = var.codepipeline_cdn_bucket_encryption_enabled
  secondary_artifact_identifier         = var.codepipeline_cdn_bucket_buildspec_identifier

  webhook_enabled             = var.webhook_enabled
  webhook_target_action       = var.webhook_target_action
  webhook_authentication      = var.webhook_authentication
  webhook_filter_json_path    = var.webhook_filter_json_path
  webhook_filter_match_equals = var.webhook_filter_match_equals

  s3_bucket_force_destroy = var.codepipeline_s3_bucket_force_destroy

  cache_type = var.codebuild_cache_type

  environment_variables = concat(
    var.build_environment_variables,
    [
      {
        name  = "CONTAINER_NAME"
        value = module.this.id
        type  = "PLAINTEXT"
      }
    ]
  )

  context = module.this.context
}

module "ecs_cloudwatch_autoscaling" {
  enabled               = var.autoscaling_enabled
  source                = "cloudposse/ecs-cloudwatch-autoscaling/aws"
  version               = "0.7.3"
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
  source  = "cloudposse/ecs-cloudwatch-sns-alarms/aws"
  version = "0.12.2"
  enabled = var.ecs_alarms_enabled

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

  context = module.this.context
}

module "alb_target_group_cloudwatch_sns_alarms" {
  source  = "cloudposse/alb-target-group-cloudwatch-sns-alarms/aws"
  version = "0.17.0"
  enabled = var.alb_target_group_alarms_enabled

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

  context = module.this.context
}

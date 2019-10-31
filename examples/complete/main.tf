provider "aws" {
  region = var.region
}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.1"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  delimiter  = var.delimiter
  attributes = var.attributes
  cidr_block = var.vpc_cidr_block
  tags       = var.tags
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.16.1"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  attributes           = var.attributes
  delimiter            = var.delimiter
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false
  tags                 = var.tags
}

module "alb" {
  source                                  = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=tags/0.7.0"
  namespace                               = var.namespace
  stage                                   = var.stage
  name                                    = var.name
  attributes                              = var.attributes
  delimiter                               = var.delimiter
  vpc_id                                  = module.vpc.vpc_id
  security_group_ids                      = [module.vpc.vpc_default_security_group_id]
  subnet_ids                              = module.subnets.public_subnet_ids
  internal                                = false
  http_enabled                            = true
  access_logs_enabled                     = false
  alb_access_logs_s3_bucket_force_destroy = true
  access_logs_region                      = var.region
  cross_zone_load_balancing_enabled       = true
  http2_enabled                           = true
  deletion_protection_enabled             = true
  tags                                    = var.tags
}

resource "aws_ecs_cluster" "default" {
  name = module.label.id
  tags = module.label.tags
}

resource "aws_sns_topic" "sns_topic" {
  name         = module.label.id
  display_name = "Test terraform-aws-ecs-web-app"
  tags         = module.label.tags
}

module "ecs_web_app" {
  source     = "../.."
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = var.attributes
  delimiter  = var.delimiter
  tags       = var.tags
  vpc_id     = module.vpc.vpc_id

  // Authentication
  authentication_type                 = var.authentication_type
  unauthenticated_priority            = var.alb_ingress_listener_unauthenticated_priority
  unauthenticated_paths               = var.alb_ingress_unauthenticated_paths
  unauthenticated_listener_arns       = [module.alb.http_listener_arn]
  unauthenticated_listener_arns_count = 1

  // AWS region for ECS and logs
  region          = var.region
  aws_logs_region = var.region

  // ECS
  ecs_private_subnet_ids = module.subnets.private_subnet_ids
  ecs_cluster_arn        = aws_ecs_cluster.default.arn
  ecs_cluster_name       = aws_ecs_cluster.default.name

  // ALB
  alb_arn_suffix     = module.alb.alb_arn_suffix
  alb_security_group = module.alb.security_group_id

  // CodePipeline
  github_oauth_token                   = var.github_oauth_token
  github_webhooks_token                = var.github_webhooks_token
  repo_owner                           = var.repo_owner
  repo_name                            = var.repo_name
  branch                               = var.branch
  build_image                          = var.build_image
  build_timeout                        = var.build_timeout
  poll_source_changes                  = var.poll_source_changes
  webhook_enabled                      = var.webhook_enabled
  codepipeline_s3_bucket_force_destroy = var.codepipeline_s3_bucket_force_destroy
  environment                          = var.environment

  // ECS alarms
  ecs_alarms_cpu_utilization_high_threshold             = var.ecs_alarms_cpu_utilization_high_threshold
  ecs_alarms_cpu_utilization_high_evaluation_periods    = var.ecs_alarms_cpu_utilization_high_evaluation_periods
  ecs_alarms_cpu_utilization_high_period                = var.ecs_alarms_cpu_utilization_high_period
  ecs_alarms_cpu_utilization_low_threshold              = var.ecs_alarms_cpu_utilization_low_threshold
  ecs_alarms_cpu_utilization_low_evaluation_periods     = var.ecs_alarms_cpu_utilization_low_evaluation_periods
  ecs_alarms_cpu_utilization_low_period                 = var.ecs_alarms_cpu_utilization_low_period
  ecs_alarms_memory_utilization_high_threshold          = var.ecs_alarms_memory_utilization_high_threshold
  ecs_alarms_memory_utilization_high_evaluation_periods = var.ecs_alarms_memory_utilization_high_evaluation_periods
  ecs_alarms_memory_utilization_high_period             = var.ecs_alarms_memory_utilization_high_period
  ecs_alarms_memory_utilization_low_threshold           = var.ecs_alarms_memory_utilization_low_threshold
  ecs_alarms_memory_utilization_low_evaluation_periods  = var.ecs_alarms_memory_utilization_low_evaluation_periods
  ecs_alarms_memory_utilization_low_period              = var.ecs_alarms_memory_utilization_low_period
  ecs_alarms_cpu_utilization_high_alarm_actions         = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_cpu_utilization_high_ok_actions            = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_cpu_utilization_low_alarm_actions          = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_cpu_utilization_low_ok_actions             = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_memory_utilization_high_alarm_actions      = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_memory_utilization_high_ok_actions         = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_memory_utilization_low_alarm_actions       = [aws_sns_topic.sns_topic.arn]
  ecs_alarms_memory_utilization_low_ok_actions          = [aws_sns_topic.sns_topic.arn]

  // ALB and Target Group alarms
  alb_target_group_alarms_evaluation_periods        = var.alb_target_group_alarms_evaluation_periods
  alb_target_group_alarms_period                    = var.alb_target_group_alarms_period
  alb_target_group_alarms_3xx_threshold             = var.alb_target_group_alarms_3xx_threshold
  alb_target_group_alarms_4xx_threshold             = var.alb_target_group_alarms_4xx_threshold
  alb_target_group_alarms_5xx_threshold             = var.alb_target_group_alarms_5xx_threshold
  alb_target_group_alarms_response_time_threshold   = var.alb_target_group_alarms_response_time_threshold
  alb_target_group_alarms_alarm_actions             = [aws_sns_topic.sns_topic.arn]
  alb_target_group_alarms_ok_actions                = [aws_sns_topic.sns_topic.arn]
  alb_target_group_alarms_insufficient_data_actions = [aws_sns_topic.sns_topic.arn]
}

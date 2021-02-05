provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.18.0"

  cidr_block = "172.16.0.0/16"

  context = module.this.context
}

data "aws_availability_zones" "available" {
}

locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "subnets" {
  source                   = "cloudposse/dynamic-subnets/aws"
  version                  = "0.32.0"
  availability_zones       = local.availability_zones
  vpc_id                   = module.vpc.vpc_id
  igw_id                   = module.vpc.igw_id
  cidr_block               = module.vpc.vpc_cidr_block
  nat_gateway_enabled      = true
  nat_instance_enabled     = false
  aws_route_create_timeout = "5m"
  aws_route_delete_timeout = "10m"

  context = module.this.context
}

module "alb" {
  source                                  = "cloudposse/alb/aws"
  version                                 = "0.23.0"
  vpc_id                                  = module.vpc.vpc_id
  security_group_ids                      = [module.vpc.vpc_default_security_group_id]
  subnet_ids                              = module.subnets.public_subnet_ids
  internal                                = false
  http_enabled                            = true
  access_logs_enabled                     = true
  alb_access_logs_s3_bucket_force_destroy = true
  cross_zone_load_balancing_enabled       = true
  http2_enabled                           = true
  deletion_protection_enabled             = false

  context = module.this.context
}

# ECS Cluster (needed even if using FARGATE launch type)
resource "aws_ecs_cluster" "default" {
  name = module.this.id
  tags = module.this.tags
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "app" {
  #bridgecrew:skip=BC_AWS_LOGGING_21:Skipping `Ensure CloudWatch logs are encrypted at rest using KMS CMKs` in example/test modules
  name              = module.this.id
  tags              = module.this.tags
  retention_in_days = 90
}

module "web_app" {
  source = "../../"

  region      = var.region
  launch_type = "FARGATE"
  vpc_id      = module.vpc.vpc_id

  container_environment = [
    {
      name  = "LAUNCH_TYPE"
      value = "FARGATE"
    },
    {
      name  = "VPC_ID"
      value = module.vpc.vpc_id
    }
  ]

  desired_count    = 1
  container_image  = var.default_container_image
  container_cpu    = 256
  container_memory = 512
  container_port   = 80
  build_timeout    = 10

  codepipeline_enabled = false
  webhook_enabled      = false
  badge_enabled        = false
  ecs_alarms_enabled   = false
  autoscaling_enabled  = false

  autoscaling_dimension             = "cpu"
  autoscaling_min_capacity          = 1
  autoscaling_max_capacity          = 2
  autoscaling_scale_up_adjustment   = 1
  autoscaling_scale_up_cooldown     = 60
  autoscaling_scale_down_adjustment = -1
  autoscaling_scale_down_cooldown   = 300

  aws_logs_region        = var.region
  ecs_cluster_arn        = aws_ecs_cluster.default.arn
  ecs_cluster_name       = aws_ecs_cluster.default.name
  ecs_security_group_ids = [module.vpc.vpc_default_security_group_id]
  ecs_private_subnet_ids = module.subnets.private_subnet_ids

  alb_security_group                              = "xxxxxxxx"
  alb_target_group_alarms_enabled                 = true
  alb_target_group_alarms_3xx_threshold           = 25
  alb_target_group_alarms_4xx_threshold           = 25
  alb_target_group_alarms_5xx_threshold           = 25
  alb_target_group_alarms_response_time_threshold = 0.5
  alb_target_group_alarms_period                  = 300
  alb_target_group_alarms_evaluation_periods      = 1

  alb_arn_suffix = module.alb.alb_arn_suffix

  alb_ingress_healthcheck_path = "/"

  # NOTE: Cognito and OIDC authentication only supported on HTTPS endpoints; here we provide `https_listener_arn` from ALB
  alb_ingress_authenticated_listener_arns       = module.alb.https_listener_arn
  alb_ingress_authenticated_listener_arns_count = 1

  # Unauthenticated paths (with higher priority than the authenticated paths)
  alb_ingress_unauthenticated_paths             = ["/events"]
  alb_ingress_listener_unauthenticated_priority = 50

  # Authenticated paths
  alb_ingress_authenticated_paths             = ["/*"]
  alb_ingress_listener_authenticated_priority = 100

  authentication_type                        = "COGNITO"
  authentication_cognito_user_pool_arn       = var.cognito_user_pool_arn
  authentication_cognito_user_pool_client_id = var.cognito_user_pool_client_id
  authentication_cognito_user_pool_domain    = var.cognito_user_pool_domain
}

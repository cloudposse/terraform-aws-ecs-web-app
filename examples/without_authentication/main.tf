provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.1"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  cidr_block = "172.16.0.0/16"
}

data "aws_availability_zones" "available" {
}

locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.16.1"
  availability_zones   = local.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  region               = var.region
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false
}

module "alb" {
  source                    = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=tags/0.7.0"
  name                      = var.name
  namespace                 = var.namespace
  stage                     = var.stage
  attributes                = compact(concat(var.attributes, ["alb"]))
  vpc_id                    = module.vpc.vpc_id
  ip_address_type           = "ipv4"
  subnet_ids                = module.subnets.public_subnet_ids
  security_group_ids        = [module.vpc.vpc_default_security_group_id]
  access_logs_region        = var.region
  https_enabled             = true
  http_ingress_cidr_blocks  = ["0.0.0.0/0"]
  https_ingress_cidr_blocks = ["0.0.0.0/0"]
  certificate_arn           = var.certificate_arn
  health_check_interval     = 60
}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
  attributes = var.attributes
  delimiter  = var.delimiter
}

# ECS Cluster (needed even if using FARGATE launch type)
resource "aws_ecs_cluster" "default" {
  name = module.label.id
}

resource "aws_cloudwatch_log_group" "app" {
  name = module.label.id
  tags = module.label.tags
}

module "web_app" {
  source     = "../../"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = compact(concat(var.attributes, ["app"]))

  region      = var.region
  launch_type = "FARGATE"
  vpc_id      = module.vpc.vpc_id

  environment = [
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
  build_timeout    = 5

  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = var.region
      "awslogs-group"         = aws_cloudwatch_log_group.app.name
      "awslogs-stream-prefix" = var.name
    }
    secretOptions = null
  }

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

  # Without authentication, both HTTP and HTTPS endpoints are supported
  alb_ingress_unauthenticated_listener_arns       = module.alb.listener_arns
  alb_ingress_unauthenticated_listener_arns_count = 2

  # All paths are unauthenticated
  alb_ingress_unauthenticated_paths             = ["/*"]
  alb_ingress_listener_unauthenticated_priority = 100
}

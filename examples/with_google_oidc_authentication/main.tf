provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.3.4"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  cidr_block = "172.16.0.0/16"
}

data "aws_availability_zones" "available" {}

locals {
  availability_zones = "${slice(data.aws_availability_zones.available.names, 0, 2)}"
}

module "subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.3.6"
  availability_zones  = "${local.availability_zones}"
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  name                = "${var.name}"
  region              = "${var.region}"
  vpc_id              = "${module.vpc.vpc_id}"
  igw_id              = "${module.vpc.igw_id}"
  cidr_block          = "${module.vpc.vpc_cidr_block}"
  nat_gateway_enabled = "true"
}

module "alb" {
  source                    = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=tags/0.2.6"
  name                      = "${var.name}"
  namespace                 = "${var.namespace}"
  stage                     = "${var.stage}"
  attributes                = ["${compact(concat(var.attributes, list("alb")))}"]
  vpc_id                    = "${module.vpc.vpc_id}"
  ip_address_type           = "ipv4"
  subnet_ids                = ["${module.subnets.public_subnet_ids}"]
  security_group_ids        = ["${module.vpc.vpc_default_security_group_id}"]
  access_logs_region        = "${var.region}"
  https_enabled             = "true"
  http_ingress_cidr_blocks  = ["0.0.0.0/0"]
  https_ingress_cidr_blocks = ["0.0.0.0/0"]
  certificate_arn           = "arn:aws:acm:us-east-2:XXXXXXXX:certificate/XXXXXX-XXXX-XXXX-XXXX-XXXXXXXX"
  health_check_interval     = "60"
}

module "ecs_cluster_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.2.1"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  tags       = "${var.tags}"
  attributes = "${var.attributes}"
  delimiter  = "${var.delimiter}"
}

# ECS Cluster (needed even if using FARGATE launch type)
resource "aws_ecs_cluster" "default" {
  name = "${module.ecs_cluster_label.id}"
}

module "web_app" {
  source     = "../../"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  attributes = ["${compact(concat(var.attributes, list("app")))}"]

  launch_type = "FARGATE"
  vpc_id      = "${module.vpc.vpc_id}"

  environment = [
    {
      name  = "LAUNCH_TYPE"
      value = "FARGATE"
    },
    {
      name  = "VPC_ID"
      value = "${module.vpc.vpc_id}"
    },
  ]

  desired_count    = 1
  container_image  = "nginxdemos/hello:latest"
  container_cpu    = "256"
  container_memory = "512"
  container_port   = "80"
  build_timeout    = 5

  port_mappings = [{
    "containerPort" = 80
    "hostPort"      = 80
    "protocol"      = "tcp"
  }]

  codepipeline_enabled = "true"
  webhook_enabled      = "true"
  badge_enabled        = "false"
  ecs_alarms_enabled   = "true"
  autoscaling_enabled  = "true"

  autoscaling_dimension             = "cpu"
  autoscaling_min_capacity          = 1
  autoscaling_max_capacity          = 2
  autoscaling_scale_up_adjustment   = "1"
  autoscaling_scale_up_cooldown     = "60"
  autoscaling_scale_down_adjustment = "-1"
  autoscaling_scale_down_cooldown   = "300"

  aws_logs_region        = "${var.region}"
  ecs_cluster_arn        = "${aws_ecs_cluster.default.arn}"
  ecs_cluster_name       = "${aws_ecs_cluster.default.name}"
  ecs_security_group_ids = ["${module.vpc.vpc_default_security_group_id}"]
  ecs_private_subnet_ids = ["${module.subnets.private_subnet_ids}"]

  alb_ingress_healthcheck_path  = "/"
  alb_ingress_paths             = ["/*"]
  alb_ingress_listener_priority = "100"

  alb_target_group_alarms_enabled                 = "true"
  alb_target_group_alarms_3xx_threshold           = "25"
  alb_target_group_alarms_4xx_threshold           = "25"
  alb_target_group_alarms_5xx_threshold           = "25"
  alb_target_group_alarms_response_time_threshold = "0.5"
  alb_target_group_alarms_period                  = "300"
  alb_target_group_alarms_evaluation_periods      = "1"

  alb_arn_suffix = "${module.alb.alb_arn_suffix}"
  alb_name       = "${module.alb.alb_name}"

  # NOTE: Cognito and OIDC authentication only supported on HTTPS endpoints; here we provide `https_listener_arn` from ALB
  listener_arns       = ["${module.alb.https_listener_arn}"]
  listener_arns_count = 1

  authentication_enabled = "true"

  authentication_action = {
    type = "authenticate-oidc"

    authenticate_oidc = [{
      # Use this URL to create a Google OAuth 2.0 Client and obtain the Client ID and Client Secret: https://console.developers.google.com/apis/credentials
      client_id     = "XXXXXXXX-XXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com"
      client_secret = "XXXXXXXXXXX_XXXXXXXX"

      # Use this URL to get Google Auth endpoints: https://accounts.google.com/.well-known/openid-configuration
      issuer                 = "https://accounts.google.com"
      authorization_endpoint = "https://accounts.google.com/o/oauth2/v2/auth"
      token_endpoint         = "https://oauth2.googleapis.com/token"
      user_info_endpoint     = "https://openidconnect.googleapis.com/v1/userinfo"
    }]
  }
}

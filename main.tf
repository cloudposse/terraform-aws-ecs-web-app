module "default_label" {
  source    = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.1.2"
  name      = "${var.name}"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
}

module "ecr" {
  source     = "git::https://github.com/cloudposse/terraform-aws-ecr.git?ref=tags/0.2.5"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  attributes = "${compact(concat(var.attributes, list("ecr")))}"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "${module.default_label.id}"
  tags = "${module.default_label.tags}"
}

module "alb_ingress" {
  source              = "git::https://github.com/cloudposse/terraform-aws-alb-ingress.git?ref=tags/0.2.2"
  name                = "${var.name}"
  namespace           = "${var.namespace}"
  stage               = "${var.stage}"
  attributes          = "${compact(concat(var.attributes, list("alb", "ingress")))}"
  vpc_id              = "${var.vpc_id}"
  listener_arns       = ["${var.listener_arns}"]
  listener_arns_count = "${var.listener_arns_count}"
  health_check_path   = "${var.alb_ingress_healthcheck_path}"
  paths               = ["${var.alb_ingress_paths}"]
  hosts               = ["${var.alb_ingress_hosts}"]
}

module "container_definition" {
  source           = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.1.3"
  container_name   = "${module.default_label.id}"
  container_image  = "${var.container_image}"
  container_memory = "${var.container_memory}"
  container_port   = "${var.container_port}"

  log_options = {
    "awslogs-region"        = "${var.aws_logs_region}"
    "awslogs-group"         = "${aws_cloudwatch_log_group.app.name}"
    "awslogs-stream-prefix" = "${var.name}"
  }
}

module "ecs_alb_service_task" {
  source                    = "git::https://github.com/cloudposse/terraform-aws-ecs-alb-service-task.git?ref=tags/0.2.0"
  name                      = "${var.name}"
  namespace                 = "${var.namespace}"
  stage                     = "${var.stage}"
  alb_target_group_arn      = "${module.alb_ingress.target_group_arn}"
  container_definition_json = "${module.container_definition.json}"
  container_name            = "${module.default_label.id}"
  ecr_repository_name       = "${module.ecr.repository_name}"
  ecs_cluster_arn           = "${var.ecs_cluster_arn}"
  launch_type               = "${var.launch_type}"
  vpc_id                    = "${var.vpc_id}"
  security_group_ids        = ["${var.ecs_security_group_ids}"]
  private_subnet_ids        = ["${var.ecs_private_subnet_ids}"]
}

module "ecs_codepipeline" {
  enabled            = "${var.codepipeline_enabled}"
  source             = "git::https://github.com/cloudposse/terraform-aws-ecs-codepipeline.git?ref=tags/0.1.1"
  name               = "${var.name}"
  namespace          = "${var.namespace}"
  stage              = "${var.stage}"
  github_oauth_token = "${var.github_oauth_token}"
  repo_owner         = "${var.repo_owner}"
  repo_name          = "${var.repo_name}"
  branch             = "${var.branch}"
  service_name       = "${module.ecs_alb_service_task.service_name}"
  ecs_cluster_name   = "${var.ecs_cluster_name}"
  privileged_mode    = "true"
}

module "ecs_alarms" {
  enabled          = "${var.ecs_alarms_enabled}"
  source           = "git::https://github.com/cloudposse/terraform-aws-ecs-cloudwatch-sns-alarms.git?ref=tags/0.2.0"
  create_sns_topic = "false"
  sns_topic_name   = "${var.sns_topic_name}"
  name             = "${var.name}"
  namespace        = "${var.namespace}"
  stage            = "${var.stage}"
  cluster_name     = "${var.ecs_cluster_name}"
  service_name     = "${module.ecs_alb_service_task.service_name}"
}

module "alb_ingress_alarms" {
  enabled                 = "${var.alb_ingress_alarms_enabled}"
  source                  = "git::https://github.com/cloudposse/terraform-aws-alb-targetgroup-cloudwatch-sns-alarms.git?ref=tags/0.1.0"
  name                    = "${var.name}"
  namespace               = "${var.namespace}"
  stage                   = "${var.stage}"
  create_sns_topic        = "false"
  sns_topic_name          = "${var.sns_topic_name}"
  alb_name                = "${var.alb_name}"
  alb_arn_suffix          = "${var.alb_arn_suffix}"
  target_group_name       = "${module.alb_ingress.target_group_name}"
  target_group_arn_suffix = "${module.alb_ingress.target_group_arn_suffix}"
}

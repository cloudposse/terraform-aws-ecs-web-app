## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb_arn_suffix | ARN suffix of the ALB for the Target Group | string | `` | no |
| alb_ingress_authenticated_hosts | Authenticated hosts to match in Hosts header | list | `<list>` | no |
| alb_ingress_authenticated_listener_arns | A list of authenticated ALB listener ARNs to attach ALB listener rules to | list | `<list>` | no |
| alb_ingress_authenticated_listener_arns_count | The number of authenticated ARNs in `alb_ingress_authenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | string | `0` | no |
| alb_ingress_authenticated_paths | Authenticated path pattern to match (a maximum of 1 can be defined) | list | `<list>` | no |
| alb_ingress_healthcheck_path | The path of the healthcheck which the ALB checks | string | `/` | no |
| alb_ingress_listener_authenticated_priority | The priority for the rules with authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_unauthenticated_priority` since a listener can't have multiple rules with the same priority | string | `300` | no |
| alb_ingress_listener_unauthenticated_priority | The priority for the rules without authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_authenticated_priority` since a listener can't have multiple rules with the same priority | string | `1000` | no |
| alb_ingress_unauthenticated_hosts | Unauthenticated hosts to match in Hosts header | list | `<list>` | no |
| alb_ingress_unauthenticated_listener_arns | A list of unauthenticated ALB listener ARNs to attach ALB listener rules to | list | `<list>` | no |
| alb_ingress_unauthenticated_listener_arns_count | The number of unauthenticated ARNs in `alb_ingress_unauthenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | string | `0` | no |
| alb_ingress_unauthenticated_paths | Unauthenticated path pattern to match (a maximum of 1 can be defined) | list | `<list>` | no |
| alb_name | Name of the ALB for the Target Group | string | `` | no |
| alb_security_group | Security group of the ALB | string | - | yes |
| alb_target_group_alarms_3xx_threshold | The maximum number of 3XX HTTPCodes in a given period for ECS Service | string | `25` | no |
| alb_target_group_alarms_4xx_threshold | The maximum number of 4XX HTTPCodes in a given period for ECS Service | string | `25` | no |
| alb_target_group_alarms_5xx_threshold | The maximum number of 5XX HTTPCodes in a given period for ECS Service | string | `25` | no |
| alb_target_group_alarms_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an ALARM state from any other state | list | `<list>` | no |
| alb_target_group_alarms_enabled | A boolean to enable/disable CloudWatch Alarms for ALB Target metrics | string | `false` | no |
| alb_target_group_alarms_evaluation_periods | The number of periods to analyze for ALB CloudWatch Alarms | string | `1` | no |
| alb_target_group_alarms_insufficient_data_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an INSUFFICIENT_DATA state from any other state | list | `<list>` | no |
| alb_target_group_alarms_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an OK state from any other state | list | `<list>` | no |
| alb_target_group_alarms_period | The period (in seconds) to analyze for ALB CloudWatch Alarms | string | `300` | no |
| alb_target_group_alarms_response_time_threshold | The maximum ALB Target Group response time | string | `0.5` | no |
| alb_target_group_arn | Pass target group down to module | string | `` | no |
| attributes | List of attributes to add to label | list | `<list>` | no |
| authentication_cognito_user_pool_arn | Cognito User Pool ARN | string | `` | no |
| authentication_cognito_user_pool_client_id | Cognito User Pool Client ID | string | `` | no |
| authentication_cognito_user_pool_domain | Cognito User Pool Domain. The User Pool Domain should be set to the domain prefix (`xxx`) instead of full domain (https://xxx.auth.us-west-2.amazoncognito.com) | string | `` | no |
| authentication_oidc_authorization_endpoint | OIDC Authorization Endpoint | string | `` | no |
| authentication_oidc_client_id | OIDC Client ID | string | `` | no |
| authentication_oidc_client_secret | OIDC Client Secret | string | `` | no |
| authentication_oidc_issuer | OIDC Issuer | string | `` | no |
| authentication_oidc_token_endpoint | OIDC Token Endpoint | string | `` | no |
| authentication_oidc_user_info_endpoint | OIDC User Info Endpoint | string | `` | no |
| authentication_type | Authentication type. Supported values are `COGNITO` and `OIDC` | string | `` | no |
| autoscaling_dimension | Dimension to autoscale on (valid options: cpu, memory) | string | `memory` | no |
| autoscaling_enabled | A boolean to enable/disable Autoscaling policy for ECS Service | string | `false` | no |
| autoscaling_max_capacity | Maximum number of running instances of a Service | string | `2` | no |
| autoscaling_min_capacity | Minimum number of running instances of a Service | string | `1` | no |
| autoscaling_scale_down_adjustment | Scaling adjustment to make during scale down event | string | `-1` | no |
| autoscaling_scale_down_cooldown | Period (in seconds) to wait between scale down events | string | `300` | no |
| autoscaling_scale_up_adjustment | Scaling adjustment to make during scale up event | string | `1` | no |
| autoscaling_scale_up_cooldown | Period (in seconds) to wait between scale up events | string | `60` | no |
| aws_logs_region | The region for the AWS Cloudwatch Logs group | string | - | yes |
| badge_enabled | Generates a publicly-accessible URL for the projects build badge. Available as badge_url attribute when enabled | string | `false` | no |
| branch | Branch of the GitHub repository, e.g. master | string | `` | no |
| build_image | Docker image for build environment, _e.g._ `aws/codebuild/docker:docker:17.09.0` | string | `aws/codebuild/docker:17.09.0` | no |
| build_timeout | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed | string | `60` | no |
| buildspec | Declaration to use for building the project. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) | string | `` | no |
| codepipeline_enabled | A boolean to enable/disable AWS Codepipeline and ECR | string | `true` | no |
| codepipeline_s3_bucket_force_destroy | A boolean that indicates all objects should be deleted from the CodePipeline artifact store S3 bucket so that the bucket can be destroyed without error | string | `false` | no |
| container_cpu | The vCPU setting to control cpu limits of container. (If FARGATE launch type is used below, this must be a supported vCPU size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) | string | `256` | no |
| container_image | The default container image to use in container definition | string | `cloudposse/default-backend` | no |
| container_memory | The amount of RAM to allow container to use in MB. (If FARGATE launch type is used below, this must be a supported Memory size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) | string | `512` | no |
| container_memory_reservation | The amount of RAM (Soft Limit) to allow container to use in MB. This value must be less than container_memory if set | string | `` | no |
| container_port | The port number on the container bound to assigned host_port | string | `80` | no |
| delimiter | The delimiter to be used in labels | string | `-` | no |
| desired_count | The desired number of tasks to start with. Set this to 0 if using DAEMON Service type. (FARGATE does not suppoert DAEMON Service type) | string | `1` | no |
| ecs_alarms_cpu_utilization_high_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High Alarm action | list | `<list>` | no |
| ecs_alarms_cpu_utilization_high_evaluation_periods | Number of periods to evaluate for the alarm | string | `1` | no |
| ecs_alarms_cpu_utilization_high_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High OK action | list | `<list>` | no |
| ecs_alarms_cpu_utilization_high_period | Duration in seconds to evaluate for the alarm | string | `300` | no |
| ecs_alarms_cpu_utilization_high_threshold | The maximum percentage of CPU utilization average | string | `80` | no |
| ecs_alarms_cpu_utilization_low_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low Alarm action | list | `<list>` | no |
| ecs_alarms_cpu_utilization_low_evaluation_periods | Number of periods to evaluate for the alarm | string | `1` | no |
| ecs_alarms_cpu_utilization_low_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low OK action | list | `<list>` | no |
| ecs_alarms_cpu_utilization_low_period | Duration in seconds to evaluate for the alarm | string | `300` | no |
| ecs_alarms_cpu_utilization_low_threshold | The minimum percentage of CPU utilization average | string | `20` | no |
| ecs_alarms_enabled | A boolean to enable/disable CloudWatch Alarms for ECS Service metrics | string | `false` | no |
| ecs_alarms_memory_utilization_high_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High Alarm action | list | `<list>` | no |
| ecs_alarms_memory_utilization_high_evaluation_periods | Number of periods to evaluate for the alarm | string | `1` | no |
| ecs_alarms_memory_utilization_high_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High OK action | list | `<list>` | no |
| ecs_alarms_memory_utilization_high_period | Duration in seconds to evaluate for the alarm | string | `300` | no |
| ecs_alarms_memory_utilization_high_threshold | The maximum percentage of Memory utilization average | string | `80` | no |
| ecs_alarms_memory_utilization_low_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low Alarm action | list | `<list>` | no |
| ecs_alarms_memory_utilization_low_evaluation_periods | Number of periods to evaluate for the alarm | string | `1` | no |
| ecs_alarms_memory_utilization_low_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low OK action | list | `<list>` | no |
| ecs_alarms_memory_utilization_low_period | Duration in seconds to evaluate for the alarm | string | `300` | no |
| ecs_alarms_memory_utilization_low_threshold | The minimum percentage of Memory utilization average | string | `20` | no |
| ecs_cluster_arn | The ECS Cluster ARN where ECS Service will be provisioned | string | - | yes |
| ecs_cluster_name | The ECS Cluster Name to use in ECS Code Pipeline Deployment step | string | - | yes |
| ecs_private_subnet_ids | List of Private Subnet IDs to provision ECS Service onto | list | - | yes |
| ecs_security_group_ids | Additional Security Group IDs to allow into ECS Service | list | `<list>` | no |
| environment | The environment variables for the task definition. This is a list of maps | list | `<list>` | no |
| github_oauth_token | GitHub Oauth Token with permissions to access private repositories | string | `` | no |
| github_webhook_events | A list of events which should trigger the webhook. See a list of [available events](https://developer.github.com/v3/activity/events/types/) | list | `<list>` | no |
| health_check_grace_period_seconds | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200. Only valid for services configured to use load balancers | string | `0` | no |
| healthcheck | A map containing command (string), interval (duration in seconds), retries (1-10, number of times to retry before marking container unhealthy, and startPeriod (0-300, optional grace period to wait, in seconds, before failed healthchecks count toward retries) | map | `<map>` | no |
| host_port | The port number to bind container_port to on the host | string | `` | no |
| launch_type | The ECS launch type (valid options: FARGATE or EC2) | string | `FARGATE` | no |
| name | Name (unique identifier for app or service) | string | - | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | string | - | yes |
| poll_source_changes | Periodically check the location of your source content and run the pipeline if changes are detected | string | `false` | no |
| port_mappings | The port mappings to configure for the container. This is a list of maps. Each map should contain "containerPort", "hostPort", and "protocol", where "protocol" is one of "tcp" or "udp". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort | list | `<list>` | no |
| protocol | The protocol used for the port mapping. Options: `tcp` or `udp` | string | `tcp` | no |
| repo_name | GitHub repository name of the application to be built and deployed to ECS | string | `` | no |
| repo_owner | GitHub Organization or Username | string | `` | no |
| secrets | The secrets for the task definition. This is a list of maps | list | `<list>` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Map of key-value pairs to use for tags | map | `<map>` | no |
| vpc_id | The VPC ID where resources are created | string | - | yes |
| webhook_authentication | The type of authentication to use. One of IP, GITHUB_HMAC, or UNAUTHENTICATED | string | `GITHUB_HMAC` | no |
| webhook_enabled | Set to false to prevent the module from creating any webhook resources | string | `true` | no |
| webhook_filter_json_path | The JSON path to filter on | string | `$.ref` | no |
| webhook_filter_match_equals | The value to match on (e.g. refs/heads/{Branch}) | string | `refs/heads/{Branch}` | no |
| webhook_target_action | The name of the action in a pipeline you want to connect to the webhook. The action must be from the source (first) stage of the pipeline | string | `Source` | no |

## Outputs

| Name | Description |
|------|-------------|
| badge_url | The URL of the build badge when `badge_enabled` is enabled |
| scale_down_policy_arn | Autoscaling scale up policy ARN |
| scale_up_policy_arn | Autoscaling scale up policy ARN |
| service_name | ECS Service Name |
| service_security_group_id | Security Group id of the ECS task |
| task_role_arn | ECS Task role ARN |
| task_role_name | ECS Task role name |
| webhook_id | The CodePipeline webhook's ARN. |
| webhook_url | The CodePipeline webhook's URL. POST events to this endpoint to trigger the target. |


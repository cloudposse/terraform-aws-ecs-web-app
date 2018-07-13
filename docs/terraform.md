
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb_arn_suffix | ARN suffix of the ALB for the Target Group. | string | `` | no |
| alb_ingress_healthcheck_path | The path of the healthcheck which the ALB checks. | string | `/` | no |
| alb_ingress_hosts | Hosts to match in Hosts header, at least one of hosts or paths must be set | list | `<list>` | no |
| alb_ingress_listener_priority | Priority of the listeners, a number between 1 - 50000 (1 is highest priority) | string | `1000` | no |
| alb_ingress_paths | Path pattern to match (a maximum of 1 can be defined), at least one of hosts or paths must be set | list | `<list>` | no |
| alb_name | Name of the ALB for the Target Group. | string | `` | no |
| alb_target_group_alarms_3xx_threshold | The maximum number of 3XX HTTPCodes in a given period for ECS Service. | string | `25` | no |
| alb_target_group_alarms_4xx_threshold | The maximum number of 4XX HTTPCodes in a given period for ECS Service. | string | `25` | no |
| alb_target_group_alarms_5xx_threshold | The maximum number of 5XX HTTPCodes in a given period for ECS Service. | string | `25` | no |
| alb_target_group_alarms_enabled | A boolean to enable/disable CloudWatch Alarms for ALB Target metrics. | string | `false` | no |
| alb_target_group_alarms_evaluation_periods | The number of periods to analyze for ALB CloudWatch Alarms. | string | `1` | no |
| alb_target_group_alarms_period | The period (in seconds) to analyze for ALB CloudWatch Alarms. | string | `300` | no |
| alb_target_group_alarms_response_time_threshold | The maximum ALB Target Group response time. | string | `0.5` | no |
| attributes | List of attributes to add to label. | list | `<list>` | no |
| aws_logs_region | The region for the AWS Cloudwatch Logs group. | string | - | yes |
| branch | Branch of the GitHub repository, e.g. master | string | `` | no |
| codepipeline_enabled | A boolean to enable/disable AWS Codepipeline and ECR | string | `true` | no |
| container_image | The default container image to use in container definition. | string | `cloudposse/default-backend` | no |
| container_memory | The amount of RAM to allow container to use in MB. | string | `128` | no |
| container_port | The port number on the container bound to assigned host_port. | string | `80` | no |
| delimiter | The delimiter to be used in labels. | string | `-` | no |
| ecs_alarms_cpu_utilization_threshold | The max percentage of CPU usage for ECS Service. | string | `80` | no |
| ecs_alarms_enabled | A boolean to enable/disable CloudWatch Alarms for ECS Service metrics. | string | `false` | no |
| ecs_alarms_evaluation_periods | The number of periods to analyze for ECS CloudWatch Alarms. | string | `1` | no |
| ecs_alarms_memory_utilization_threshold | The max percentage of Memory usage for ECS Service. | string | `80` | no |
| ecs_alarms_period | The period (in seconds) to analyze for ECS CloudWatch Alarms. | string | `300` | no |
| ecs_cluster_arn | The ECS Cluster ARN where ECS Service will be provisioned. | string | - | yes |
| ecs_cluster_name | The ECS Cluster Name to use in ECS Code Pipeline Deployment step. | string | - | yes |
| ecs_private_subnet_ids | List of Private Subnet IDs to provision ECS Service onto. | list | - | yes |
| ecs_security_group_ids | Additional Security Group IDs to allow into ECS Service. | list | `<list>` | no |
| github_oauth_token | GitHub Oauth Token with permissions to access private repositories | string | `` | no |
| healthcheck | A map containing command (string), interval (duration in seconds), retries (1-10, number of times to retry before marking container unhealthy, and startPeriod (0-300, optional grace period to wait, in seconds, before failed healthchecks count toward retries) | map | `<map>` | no |
| host_port | The port number to bind container_port to on the host | string | `` | no |
| launch_type | The ECS launch type (valid options: FARGATE or EC2) | string | `FARGATE` | no |
| listener_arns | List of ALB Listener ARNs for the ECS service. | list | - | yes |
| listener_arns_count | Number of elements in list of ALB Listener ARNs for the ECS service. | string | - | yes |
| name | Name (unique identifier for app or service) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| notify_arns | List of ARNs to send notifications on CloudWatch `ALARM` and `OK` actions. | list | - | yes |
| protocol | The protocol used for the port mapping. Options: tcp or udp. | string | `tcp` | no |
| repo_name | GitHub repository name of the application to be built and deployed to ECS. | string | `` | no |
| repo_owner | GitHub Organization or Username. | string | `` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Map of key-value pairs to use for tags. | map | `<map>` | no |
| vpc_id | The VPC ID where resources are created. | string | - | yes |


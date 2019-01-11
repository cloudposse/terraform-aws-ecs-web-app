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
| alb_target_group_alarms_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an ALARM state from any other state. | list | `<list>` | no |
| alb_target_group_alarms_enabled | A boolean to enable/disable CloudWatch Alarms for ALB Target metrics. | string | `false` | no |
| alb_target_group_alarms_evaluation_periods | The number of periods to analyze for ALB CloudWatch Alarms. | string | `1` | no |
| alb_target_group_alarms_insufficient_data_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an INSUFFICIENT_DATA state from any other state. | list | `<list>` | no |
| alb_target_group_alarms_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an OK state from any other state. | list | `<list>` | no |
| alb_target_group_alarms_period | The period (in seconds) to analyze for ALB CloudWatch Alarms. | string | `300` | no |
| alb_target_group_alarms_response_time_threshold | The maximum ALB Target Group response time. | string | `0.5` | no |
| alb_target_group_arn | Pass target group down to module | string | `` | no |
| attributes | List of attributes to add to label. | list | `<list>` | no |
| autoscaling_dimension | Dimension to autoscale on (valid options: cpu, memory) | string | `memory` | no |
| autoscaling_enabled | A boolean to enable/disable Autoscaling policy for ECS Service. | string | `false` | no |
| autoscaling_max_capacity | Maximum number of running instances of a Service. | string | `2` | no |
| autoscaling_min_capacity | Minimum number of running instances of a Service. | string | `1` | no |
| autoscaling_scale_down_adjustment | Scaling adjustment to make during scale down event. | string | `-1` | no |
| autoscaling_scale_down_cooldown | Period (in seconds) to wait between scale down events. | string | `300` | no |
| autoscaling_scale_up_adjustment | Scaling adjustment to make during scale up event. | string | `1` | no |
| autoscaling_scale_up_cooldown | Period (in seconds) to wait between scale up events. | string | `60` | no |
| aws_logs_region | The region for the AWS Cloudwatch Logs group. | string | - | yes |
| branch | Branch of the GitHub repository, e.g. master | string | `` | no |
| codepipeline_enabled | A boolean to enable/disable AWS Codepipeline and ECR | string | `true` | no |
| container_cpu | The vCPU setting to control cpu limits of container. (If FARGATE launch type is used below, this must be a supported vCPU size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) | string | `256` | no |
| container_image | The default container image to use in container definition. | string | `cloudposse/default-backend` | no |
| container_memory | The amount of RAM to allow container to use in MB. (If FARGATE launch type is used below, this must be a supported Memory size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) | string | `512` | no |
| container_memory_reservation | The amount of RAM (Soft Limit) to allow container to use in MB. This value must be less than container_memory if set. | string | `` | no |
| container_port | The port number on the container bound to assigned host_port. | string | `80` | no |
| delimiter | The delimiter to be used in labels. | string | `-` | no |
| desired_count | The desired number of tasks to start with. Set this to 0 if using DAEMON Service type. (FARGATE does not suppoert DAEMON Service type) | string | `1` | no |
| ecs_alarms_cpu_utilization_high_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High Alarm action. | list | `<list>` | no |
| ecs_alarms_cpu_utilization_high_evaluation_periods | Number of periods to evaluate for the alarm. | string | `1` | no |
| ecs_alarms_cpu_utilization_high_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High OK action. | list | `<list>` | no |
| ecs_alarms_cpu_utilization_high_period | Duration in seconds to evaluate for the alarm. | string | `300` | no |
| ecs_alarms_cpu_utilization_high_threshold | The maximum percentage of CPU utilization average. | string | `80` | no |
| ecs_alarms_cpu_utilization_low_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low Alarm action. | list | `<list>` | no |
| ecs_alarms_cpu_utilization_low_evaluation_periods | Number of periods to evaluate for the alarm. | string | `1` | no |
| ecs_alarms_cpu_utilization_low_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low OK action. | list | `<list>` | no |
| ecs_alarms_cpu_utilization_low_period | Duration in seconds to evaluate for the alarm. | string | `300` | no |
| ecs_alarms_cpu_utilization_low_threshold | The minimum percentage of CPU utilization average. | string | `20` | no |
| ecs_alarms_enabled | A boolean to enable/disable CloudWatch Alarms for ECS Service metrics. | string | `false` | no |
| ecs_alarms_memory_utilization_high_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High Alarm action. | list | `<list>` | no |
| ecs_alarms_memory_utilization_high_evaluation_periods | Number of periods to evaluate for the alarm. | string | `1` | no |
| ecs_alarms_memory_utilization_high_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High OK action. | list | `<list>` | no |
| ecs_alarms_memory_utilization_high_period | Duration in seconds to evaluate for the alarm. | string | `300` | no |
| ecs_alarms_memory_utilization_high_threshold | The maximum percentage of Memory utilization average. | string | `80` | no |
| ecs_alarms_memory_utilization_low_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low Alarm action. | list | `<list>` | no |
| ecs_alarms_memory_utilization_low_evaluation_periods | Number of periods to evaluate for the alarm. | string | `1` | no |
| ecs_alarms_memory_utilization_low_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low OK action. | list | `<list>` | no |
| ecs_alarms_memory_utilization_low_period | Duration in seconds to evaluate for the alarm. | string | `300` | no |
| ecs_alarms_memory_utilization_low_threshold | The minimum percentage of Memory utilization average. | string | `20` | no |
| ecs_cluster_arn | The ECS Cluster ARN where ECS Service will be provisioned. | string | - | yes |
| ecs_cluster_name | The ECS Cluster Name to use in ECS Code Pipeline Deployment step. | string | - | yes |
| ecs_private_subnet_ids | List of Private Subnet IDs to provision ECS Service onto. | list | - | yes |
| ecs_security_group_ids | Additional Security Group IDs to allow into ECS Service. | list | `<list>` | no |
| environment | The environment variables for the task definition. This is a list of maps | list | `<list>` | no |
| github_oauth_token | GitHub Oauth Token with permissions to access private repositories | string | `` | no |
| healthcheck | A map containing command (string), interval (duration in seconds), retries (1-10, number of times to retry before marking container unhealthy, and startPeriod (0-300, optional grace period to wait, in seconds, before failed healthchecks count toward retries) | map | `<map>` | no |
| host_port | The port number to bind container_port to on the host | string | `` | no |
| launch_type | The ECS launch type (valid options: FARGATE or EC2) | string | `FARGATE` | no |
| listener_arns | List of ALB Listener ARNs for the ECS service. | list | - | yes |
| listener_arns_count | Number of elements in list of ALB Listener ARNs for the ECS service. | string | - | yes |
| name | Name (unique identifier for app or service) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| port_mappings | The port mappings to configure for the container. This is a list of maps. Each map should contain "containerPort", "hostPort", and "protocol", where "protocol" is one of "tcp" or "udp". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort. | list | `<list>` | no |
| protocol | The protocol used for the port mapping. Options: tcp or udp. | string | `tcp` | no |
| repo_name | GitHub repository name of the application to be built and deployed to ECS. | string | `` | no |
| repo_owner | GitHub Organization or Username. | string | `` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Map of key-value pairs to use for tags. | map | `<map>` | no |
| vpc_id | The VPC ID where resources are created. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| scale_down_policy_arn | Autoscaling scale up policy ARN |
| scale_up_policy_arn | Autoscaling scale up policy ARN |
| service_name | ECS Service Name |
| service_security_group_id | Security Group id of the ECS task |
| task_role_arn | ECS Task role ARN |
| task_role_name | ECS Task role name |


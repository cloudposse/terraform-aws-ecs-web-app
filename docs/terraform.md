<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |
| aws | >= 2.0 |
| local | >= 1.3 |
| null | >= 2.0 |
| template | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_arn\_suffix | ARN suffix of the ALB for the Target Group | `string` | `""` | no |
| alb\_container\_name | The name of the container to associate with the ALB. If not provided, the generated container will be used | `string` | `null` | no |
| alb\_ingress\_authenticated\_hosts | Authenticated hosts to match in Hosts header | `list(string)` | `[]` | no |
| alb\_ingress\_authenticated\_listener\_arns | A list of authenticated ALB listener ARNs to attach ALB listener rules to | `list(string)` | `[]` | no |
| alb\_ingress\_authenticated\_listener\_arns\_count | The number of authenticated ARNs in `alb_ingress_authenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | `number` | `0` | no |
| alb\_ingress\_authenticated\_paths | Authenticated path pattern to match (a maximum of 1 can be defined) | `list(string)` | `[]` | no |
| alb\_ingress\_enable\_default\_target\_group | If true, create a default target group for the ALB ingress | `bool` | `true` | no |
| alb\_ingress\_healthcheck\_path | The path of the healthcheck which the ALB checks | `string` | `"/"` | no |
| alb\_ingress\_healthcheck\_protocol | The protocol to use to connect with the target. Defaults to `HTTP`. Not applicable when `target_type` is `lambda` | `string` | `"HTTP"` | no |
| alb\_ingress\_listener\_authenticated\_priority | The priority for the rules with authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_unauthenticated_priority` since a listener can't have multiple rules with the same priority | `number` | `300` | no |
| alb\_ingress\_listener\_unauthenticated\_priority | The priority for the rules without authentication, between 1 and 50000 (1 being highest priority). Must be different from `alb_ingress_listener_authenticated_priority` since a listener can't have multiple rules with the same priority | `number` | `1000` | no |
| alb\_ingress\_target\_group\_arn | Existing ALB target group ARN. If provided, set `alb_ingress_enable_default_target_group` to `false` to disable creation of the default target group | `string` | `""` | no |
| alb\_ingress\_unauthenticated\_hosts | Unauthenticated hosts to match in Hosts header | `list(string)` | `[]` | no |
| alb\_ingress\_unauthenticated\_listener\_arns | A list of unauthenticated ALB listener ARNs to attach ALB listener rules to | `list(string)` | `[]` | no |
| alb\_ingress\_unauthenticated\_listener\_arns\_count | The number of unauthenticated ARNs in `alb_ingress_unauthenticated_listener_arns`. This is necessary to work around a limitation in Terraform where counts cannot be computed | `number` | `0` | no |
| alb\_ingress\_unauthenticated\_paths | Unauthenticated path pattern to match (a maximum of 1 can be defined) | `list(string)` | `[]` | no |
| alb\_security\_group | Security group of the ALB | `string` | n/a | yes |
| alb\_target\_group\_alarms\_3xx\_threshold | The maximum number of 3XX HTTPCodes in a given period for ECS Service | `number` | `25` | no |
| alb\_target\_group\_alarms\_4xx\_threshold | The maximum number of 4XX HTTPCodes in a given period for ECS Service | `number` | `25` | no |
| alb\_target\_group\_alarms\_5xx\_threshold | The maximum number of 5XX HTTPCodes in a given period for ECS Service | `number` | `25` | no |
| alb\_target\_group\_alarms\_alarm\_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an ALARM state from any other state | `list(string)` | `[]` | no |
| alb\_target\_group\_alarms\_enabled | A boolean to enable/disable CloudWatch Alarms for ALB Target metrics | `bool` | `false` | no |
| alb\_target\_group\_alarms\_evaluation\_periods | The number of periods to analyze for ALB CloudWatch Alarms | `number` | `1` | no |
| alb\_target\_group\_alarms\_insufficient\_data\_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an INSUFFICIENT\_DATA state from any other state | `list(string)` | `[]` | no |
| alb\_target\_group\_alarms\_ok\_actions | A list of ARNs (i.e. SNS Topic ARN) to execute when ALB Target Group alarms transition into an OK state from any other state | `list(string)` | `[]` | no |
| alb\_target\_group\_alarms\_period | The period (in seconds) to analyze for ALB CloudWatch Alarms | `number` | `300` | no |
| alb\_target\_group\_alarms\_response\_time\_threshold | The maximum ALB Target Group response time | `number` | `0.5` | no |
| assign\_public\_ip | Assign a public IP address to the ENI (Fargate launch type only). Valid values are `true` or `false`. Default `false` | `bool` | `false` | no |
| attributes | Additional attributes (\_e.g.\_ "1") | `list(string)` | `[]` | no |
| authentication\_cognito\_scope | Cognito scope | `list(string)` | `[]` | no |
| authentication\_cognito\_user\_pool\_arn | Cognito User Pool ARN | `string` | `""` | no |
| authentication\_cognito\_user\_pool\_client\_id | Cognito User Pool Client ID | `string` | `""` | no |
| authentication\_cognito\_user\_pool\_domain | Cognito User Pool Domain. The User Pool Domain should be set to the domain prefix (`xxx`) instead of full domain (https://xxx.auth.us-west-2.amazoncognito.com) | `string` | `""` | no |
| authentication\_oidc\_authorization\_endpoint | OIDC Authorization Endpoint | `string` | `""` | no |
| authentication\_oidc\_client\_id | OIDC Client ID | `string` | `""` | no |
| authentication\_oidc\_client\_secret | OIDC Client Secret | `string` | `""` | no |
| authentication\_oidc\_issuer | OIDC Issuer | `string` | `""` | no |
| authentication\_oidc\_scope | OIDC scope | `list(string)` | `[]` | no |
| authentication\_oidc\_token\_endpoint | OIDC Token Endpoint | `string` | `""` | no |
| authentication\_oidc\_user\_info\_endpoint | OIDC User Info Endpoint | `string` | `""` | no |
| authentication\_type | Authentication type. Supported values are `COGNITO` and `OIDC` | `string` | `""` | no |
| autoscaling\_dimension | Dimension to autoscale on (valid options: cpu, memory) | `string` | `"memory"` | no |
| autoscaling\_enabled | A boolean to enable/disable Autoscaling policy for ECS Service | `bool` | `false` | no |
| autoscaling\_max\_capacity | Maximum number of running instances of a Service | `number` | `2` | no |
| autoscaling\_min\_capacity | Minimum number of running instances of a Service | `number` | `1` | no |
| autoscaling\_scale\_down\_adjustment | Scaling adjustment to make during scale down event | `number` | `-1` | no |
| autoscaling\_scale\_down\_cooldown | Period (in seconds) to wait between scale down events | `number` | `300` | no |
| autoscaling\_scale\_up\_adjustment | Scaling adjustment to make during scale up event | `number` | `1` | no |
| autoscaling\_scale\_up\_cooldown | Period (in seconds) to wait between scale up events | `number` | `60` | no |
| aws\_logs\_region | The region for the AWS Cloudwatch Logs group | `string` | n/a | yes |
| badge\_enabled | Generates a publicly-accessible URL for the projects build badge. Available as badge\_url attribute when enabled | `bool` | `false` | no |
| branch | Branch of the GitHub repository, e.g. `master` | `string` | `""` | no |
| build\_environment\_variables | A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build | <pre>list(object(<br>    {<br>      name  = string<br>      value = string<br>  }))</pre> | `[]` | no |
| build\_image | Docker image for build environment, _e.g._ `aws/codebuild/docker:docker:17.09.0` | `string` | `"aws/codebuild/docker:17.09.0"` | no |
| build\_timeout | How long in minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed | `number` | `60` | no |
| buildspec | Declaration to use for building the project. [For more info](http://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) | `string` | `""` | no |
| capacity\_provider\_strategies | The capacity provider strategies to use for the service. See `capacity_provider_strategy` configuration block: https://www.terraform.io/docs/providers/aws/r/ecs_service.html#capacity_provider_strategy | <pre>list(object({<br>    capacity_provider = string<br>    weight            = number<br>    base              = number<br>  }))</pre> | `[]` | no |
| cloudwatch\_log\_group\_enabled | A boolean to disable cloudwatch log group creation | `bool` | `true` | no |
| codepipeline\_build\_compute\_type | `CodeBuild` instance size. Possible values are: `BUILD_GENERAL1_SMALL` `BUILD_GENERAL1_MEDIUM` `BUILD_GENERAL1_LARGE` | `string` | `"BUILD_GENERAL1_SMALL"` | no |
| codepipeline\_enabled | A boolean to enable/disable AWS Codepipeline and ECR | `bool` | `true` | no |
| codepipeline\_s3\_bucket\_force\_destroy | A boolean that indicates all objects should be deleted from the CodePipeline artifact store S3 bucket so that the bucket can be destroyed without error | `bool` | `false` | no |
| command | The command that is passed to the container | `list(string)` | `null` | no |
| container\_cpu | The vCPU setting to control cpu limits of container. (If FARGATE launch type is used below, this must be a supported vCPU size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) | `number` | `256` | no |
| container\_definition | Override the main container\_definition | `string` | `""` | no |
| container\_image | The default container image to use in container definition | `string` | `"cloudposse/default-backend"` | no |
| container\_memory | The amount of RAM to allow container to use in MB. (If FARGATE launch type is used below, this must be a supported Memory size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) | `number` | `512` | no |
| container\_memory\_reservation | The amount of RAM (Soft Limit) to allow container to use in MB. This value must be less than `container_memory` if set | `number` | `128` | no |
| container\_port | The port number on the container bound to assigned host\_port | `number` | `80` | no |
| container\_start\_timeout | Time duration (in seconds) to wait before giving up on resolving dependencies for a container | `number` | `30` | no |
| container\_stop\_timeout | Time duration (in seconds) to wait before the container is forcefully killed if it doesn't exit normally on its own | `number` | `30` | no |
| delimiter | Delimiter between `namespace`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| deployment\_controller\_type | Type of deployment controller. Valid values are CODE\_DEPLOY and ECS | `string` | `"ECS"` | no |
| desired\_count | The desired number of tasks to start with. Set this to 0 if using DAEMON Service type. (FARGATE does not suppoert DAEMON Service type) | `number` | `1` | no |
| ecr\_scan\_images\_on\_push | Indicates whether images are scanned after being pushed to the repository (true) or not (false) | `bool` | `false` | no |
| ecs\_alarms\_cpu\_utilization\_high\_alarm\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High Alarm action | `list(string)` | `[]` | no |
| ecs\_alarms\_cpu\_utilization\_high\_evaluation\_periods | Number of periods to evaluate for the alarm | `number` | `1` | no |
| ecs\_alarms\_cpu\_utilization\_high\_ok\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High OK action | `list(string)` | `[]` | no |
| ecs\_alarms\_cpu\_utilization\_high\_period | Duration in seconds to evaluate for the alarm | `number` | `300` | no |
| ecs\_alarms\_cpu\_utilization\_high\_threshold | The maximum percentage of CPU utilization average | `number` | `80` | no |
| ecs\_alarms\_cpu\_utilization\_low\_alarm\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low Alarm action | `list(string)` | `[]` | no |
| ecs\_alarms\_cpu\_utilization\_low\_evaluation\_periods | Number of periods to evaluate for the alarm | `number` | `1` | no |
| ecs\_alarms\_cpu\_utilization\_low\_ok\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low OK action | `list(string)` | `[]` | no |
| ecs\_alarms\_cpu\_utilization\_low\_period | Duration in seconds to evaluate for the alarm | `number` | `300` | no |
| ecs\_alarms\_cpu\_utilization\_low\_threshold | The minimum percentage of CPU utilization average | `number` | `20` | no |
| ecs\_alarms\_enabled | A boolean to enable/disable CloudWatch Alarms for ECS Service metrics | `bool` | `false` | no |
| ecs\_alarms\_memory\_utilization\_high\_alarm\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High Alarm action | `list(string)` | `[]` | no |
| ecs\_alarms\_memory\_utilization\_high\_evaluation\_periods | Number of periods to evaluate for the alarm | `number` | `1` | no |
| ecs\_alarms\_memory\_utilization\_high\_ok\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High OK action | `list(string)` | `[]` | no |
| ecs\_alarms\_memory\_utilization\_high\_period | Duration in seconds to evaluate for the alarm | `number` | `300` | no |
| ecs\_alarms\_memory\_utilization\_high\_threshold | The maximum percentage of Memory utilization average | `number` | `80` | no |
| ecs\_alarms\_memory\_utilization\_low\_alarm\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low Alarm action | `list(string)` | `[]` | no |
| ecs\_alarms\_memory\_utilization\_low\_evaluation\_periods | Number of periods to evaluate for the alarm | `number` | `1` | no |
| ecs\_alarms\_memory\_utilization\_low\_ok\_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low OK action | `list(string)` | `[]` | no |
| ecs\_alarms\_memory\_utilization\_low\_period | Duration in seconds to evaluate for the alarm | `number` | `300` | no |
| ecs\_alarms\_memory\_utilization\_low\_threshold | The minimum percentage of Memory utilization average | `number` | `20` | no |
| ecs\_cluster\_arn | The ECS Cluster ARN where ECS Service will be provisioned | `string` | n/a | yes |
| ecs\_cluster\_name | The ECS Cluster Name to use in ECS Code Pipeline Deployment step | `string` | n/a | yes |
| ecs\_private\_subnet\_ids | List of Private Subnet IDs to provision ECS Service onto | `list(string)` | n/a | yes |
| ecs\_security\_group\_ids | Additional Security Group IDs to allow into ECS Service | `list(string)` | `[]` | no |
| entrypoint | The entry point that is passed to the container | `list(string)` | `null` | no |
| environment | The environment variables to pass to the container. This is a list of maps | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `null` | no |
| github\_oauth\_token | GitHub Oauth Token with permissions to access private repositories | `string` | `""` | no |
| github\_webhook\_events | A list of events which should trigger the webhook. See a list of [available events](https://developer.github.com/v3/activity/events/types/) | `list(string)` | <pre>[<br>  "push"<br>]</pre> | no |
| github\_webhooks\_anonymous | Github Anonymous API (if `true`, token must not be set as GITHUB\_TOKEN or `github_webhooks_token`) | `bool` | `false` | no |
| github\_webhooks\_token | GitHub OAuth Token with permissions to create webhooks. If not provided, can be sourced from the `GITHUB_TOKEN` environment variable | `string` | `""` | no |
| health\_check\_grace\_period\_seconds | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200. Only valid for services configured to use load balancers | `number` | `0` | no |
| healthcheck | A map containing command (string), timeout, interval (duration in seconds), retries (1-10, number of times to retry before marking container unhealthy), and startPeriod (0-300, optional grace period to wait, in seconds, before failed healthchecks count toward retries) | <pre>object({<br>    command     = list(string)<br>    retries     = number<br>    timeout     = number<br>    interval    = number<br>    startPeriod = number<br>  })</pre> | `null` | no |
| ignore\_changes\_task\_definition | Ignore changes (like environment variables) to the ECS task definition | `bool` | `true` | no |
| init\_containers | A list of additional init containers to start. The map contains the container\_definition (JSON) and the main container's dependency condition (string) on the init container. The latter can be one of START, COMPLETE, SUCCESS or HEALTHY. | <pre>list(object({<br>    container_definition = any<br>    condition            = string<br>  }))</pre> | `[]` | no |
| launch\_type | The ECS launch type (valid options: FARGATE or EC2) | `string` | `"FARGATE"` | no |
| log\_driver | The log driver to use for the container. If using Fargate launch type, only supported value is awslogs | `string` | `"awslogs"` | no |
| log\_retention\_in\_days | The number of days to retain logs for the log group | `number` | `null` | no |
| map\_environment | The environment variables to pass to the container. This is a map of string: {key: value}. `environment` overrides `map_environment` | `map(string)` | `null` | no |
| mount\_points | Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume` | <pre>list(object({<br>    containerPath = string<br>    sourceVolume  = string<br>  }))</pre> | `[]` | no |
| name | Name of the application | `string` | n/a | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | `string` | `""` | no |
| nlb\_cidr\_blocks | A list of CIDR blocks to add to the ingress rule for the NLB container port | `list(string)` | `[]` | no |
| nlb\_container\_name | The name of the container to associate with the NLB. If not provided, the generated container will be used | `string` | `null` | no |
| nlb\_container\_port | The port number on the container bound to assigned NLB host\_port | `number` | `80` | no |
| nlb\_ingress\_target\_group\_arn | Target group ARN of the NLB ingress | `string` | `""` | no |
| platform\_version | The platform version on which to run your service. Only applicable for launch\_type set to FARGATE. More information about Fargate platform versions can be found in the AWS ECS User Guide. | `string` | `"LATEST"` | no |
| poll\_source\_changes | Periodically check the location of your source content and run the pipeline if changes are detected | `bool` | `false` | no |
| port\_mappings | The port mappings to configure for the container. This is a list of maps. Each map should contain "containerPort", "hostPort", and "protocol", where "protocol" is one of "tcp" or "udp". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort | <pre>list(object({<br>    containerPort = number<br>    hostPort      = number<br>    protocol      = string<br>  }))</pre> | <pre>[<br>  {<br>    "containerPort": 80,<br>    "hostPort": 80,<br>    "protocol": "tcp"<br>  }<br>]</pre> | no |
| privileged | When this variable is `true`, the container is given elevated privileges on the host container instance (similar to the root user). This parameter is not supported for Windows containers or tasks using the Fargate launch type. Due to how Terraform type casts booleans in json it is required to double quote this value | `string` | `null` | no |
| region | AWS Region for S3 bucket | `string` | n/a | yes |
| repo\_name | GitHub repository name of the application to be built and deployed to ECS | `string` | `""` | no |
| repo\_owner | GitHub Organization or Username | `string` | `""` | no |
| secrets | The secrets to pass to the container. This is a list of maps | <pre>list(object({<br>    name      = string<br>    valueFrom = string<br>  }))</pre> | `null` | no |
| service\_registries | The service discovery registries for the service. The maximum number of service\_registries blocks is 1. The currently supported service registry is Amazon Route 53 Auto Naming Service - `aws_service_discovery_service`; see `service_registries` docs https://www.terraform.io/docs/providers/aws/r/ecs_service.html#service_registries-1 | <pre>list(object({<br>    registry_arn   = string<br>    port           = number<br>    container_name = string<br>    container_port = number<br>  }))</pre> | `[]` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | `""` | no |
| system\_controls | A list of namespaced kernel parameters to set in the container, mapping to the --sysctl option to docker run. This is a list of maps: { namespace = "", value = ""} | `list(map(string))` | `null` | no |
| tags | Additional tags (\_e.g.\_ { BusinessUnit : ABC }) | `map(string)` | `{}` | no |
| task\_cpu | The number of CPU units used by the task. If unspecified, it will default to `container_cpu`. If using `FARGATE` launch type `task_cpu` must match supported memory values (https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size) | `number` | `null` | no |
| task\_memory | The amount of memory (in MiB) used by the task. If unspecified, it will default to `container_memory`. If using Fargate launch type `task_memory` must match supported cpu value (https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size) | `number` | `null` | no |
| ulimits | The ulimits to configure for the container. This is a list of maps. Each map should contain "name", "softLimit" and "hardLimit" | <pre>list(object({<br>    name      = string<br>    softLimit = number<br>    hardLimit = number<br>  }))</pre> | `[]` | no |
| use\_alb\_security\_group | A boolean to enable adding an ALB security group rule for the service task | `bool` | `false` | no |
| use\_ecr\_image | If true, use ECR repo URL for image, otherwise use value in container\_image | `bool` | `false` | no |
| use\_nlb\_cidr\_blocks | A flag to enable/disable adding the NLB ingress rule to the security group | `bool` | `false` | no |
| volumes | Task volume definitions as list of configuration objects | <pre>list(object({<br>    host_path = string<br>    name      = string<br>    docker_volume_configuration = list(object({<br>      autoprovision = bool<br>      driver        = string<br>      driver_opts   = map(string)<br>      labels        = map(string)<br>      scope         = string<br>    }))<br>    efs_volume_configuration = list(object({<br>      file_system_id          = string<br>      root_directory          = string<br>      transit_encryption      = string<br>      transit_encryption_port = string<br>      authorization_config = list(object({<br>        access_point_id = string<br>        iam             = string<br>      }))<br>    }))<br>  }))</pre> | `[]` | no |
| vpc\_id | The VPC ID where resources are created | `string` | n/a | yes |
| webhook\_authentication | The type of authentication to use. One of IP, GITHUB\_HMAC, or UNAUTHENTICATED | `string` | `"GITHUB_HMAC"` | no |
| webhook\_enabled | Set to false to prevent the module from creating any webhook resources | `bool` | `true` | no |
| webhook\_filter\_json\_path | The JSON path to filter on | `string` | `"$.ref"` | no |
| webhook\_filter\_match\_equals | The value to match on (e.g. refs/heads/{Branch}) | `string` | `"refs/heads/{Branch}"` | no |
| webhook\_target\_action | The name of the action in a pipeline you want to connect to the webhook. The action must be from the source (first) stage of the pipeline | `string` | `"Source"` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb\_ingress | All outputs from `module.alb_ingress` |
| alb\_ingress\_target\_group\_arn | ALB Target Group ARN |
| alb\_ingress\_target\_group\_arn\_suffix | ALB Target Group ARN suffix |
| alb\_ingress\_target\_group\_name | ALB Target Group name |
| alb\_target\_group\_cloudwatch\_sns\_alarms | All outputs from `module.alb_target_group_cloudwatch_sns_alarms` |
| cloudwatch\_log\_group | All outputs from `aws_cloudwatch_log_group.app` |
| cloudwatch\_log\_group\_arn | Cloudwatch log group ARN |
| cloudwatch\_log\_group\_name | Cloudwatch log group name |
| codebuild | All outputs from `module.ecs_codepipeline` |
| codebuild\_badge\_url | The URL of the build badge when badge\_enabled is enabled |
| codebuild\_cache\_bucket\_arn | CodeBuild cache S3 bucket ARN |
| codebuild\_cache\_bucket\_name | CodeBuild cache S3 bucket name |
| codebuild\_project\_id | CodeBuild project ID |
| codebuild\_project\_name | CodeBuild project name |
| codebuild\_role\_arn | CodeBuild IAM Role ARN |
| codebuild\_role\_id | CodeBuild IAM Role ID |
| codepipeline\_arn | CodePipeline ARN |
| codepipeline\_id | CodePipeline ID |
| codepipeline\_webhook\_id | The CodePipeline webhook's ID |
| codepipeline\_webhook\_url | The CodePipeline webhook's URL. POST events to this endpoint to trigger the target |
| container\_definition | All outputs from `module.container_definition` |
| container\_definition\_json | JSON encoded list of container definitions for use with other terraform resources such as aws\_ecs\_task\_definition |
| container\_definition\_json\_map | JSON encoded container definitions for use with other terraform resources such as aws\_ecs\_task\_definition |
| ecr | All outputs from `module.ecr` |
| ecr\_registry\_id | Registry ID |
| ecr\_registry\_url | Repository URL |
| ecr\_repository\_arn | ARN of ECR repository |
| ecr\_repository\_name | Registry name |
| ecr\_repository\_url | Repository URL |
| ecs\_alarms | All outputs from `module.ecs_cloudwatch_sns_alarms` |
| ecs\_alarms\_cpu\_utilization\_high\_cloudwatch\_metric\_alarm\_arn | ECS CPU utilization high CloudWatch metric alarm ARN |
| ecs\_alarms\_cpu\_utilization\_high\_cloudwatch\_metric\_alarm\_id | ECS CPU utilization high CloudWatch metric alarm ID |
| ecs\_alarms\_cpu\_utilization\_low\_cloudwatch\_metric\_alarm\_arn | ECS CPU utilization low CloudWatch metric alarm ARN |
| ecs\_alarms\_cpu\_utilization\_low\_cloudwatch\_metric\_alarm\_id | ECS CPU utilization low CloudWatch metric alarm ID |
| ecs\_alarms\_memory\_utilization\_high\_cloudwatch\_metric\_alarm\_arn | ECS Memory utilization high CloudWatch metric alarm ARN |
| ecs\_alarms\_memory\_utilization\_high\_cloudwatch\_metric\_alarm\_id | ECS Memory utilization high CloudWatch metric alarm ID |
| ecs\_alarms\_memory\_utilization\_low\_cloudwatch\_metric\_alarm\_arn | ECS Memory utilization low CloudWatch metric alarm ARN |
| ecs\_alarms\_memory\_utilization\_low\_cloudwatch\_metric\_alarm\_id | ECS Memory utilization low CloudWatch metric alarm ID |
| ecs\_alb\_service\_task | All outputs from `module.ecs_alb_service_task` |
| ecs\_cloudwatch\_autoscaling | All outputs from `module.ecs_cloudwatch_autoscaling` |
| ecs\_cloudwatch\_autoscaling\_scale\_down\_policy\_arn | ARN of the scale down policy |
| ecs\_cloudwatch\_autoscaling\_scale\_up\_policy\_arn | ARN of the scale up policy |
| ecs\_exec\_role\_policy\_id | The ECS service role policy ID, in the form of `role_name:role_policy_name` |
| ecs\_exec\_role\_policy\_name | ECS service role name |
| ecs\_service\_name | ECS Service name |
| ecs\_service\_role\_arn | ECS Service role ARN |
| ecs\_service\_security\_group\_id | Security Group ID of the ECS task |
| ecs\_task\_definition\_family | ECS task definition family |
| ecs\_task\_definition\_revision | ECS task definition revision |
| ecs\_task\_exec\_role\_arn | ECS Task exec role ARN |
| ecs\_task\_exec\_role\_name | ECS Task role name |
| ecs\_task\_role\_arn | ECS Task role ARN |
| ecs\_task\_role\_id | ECS Task role id |
| ecs\_task\_role\_name | ECS Task role name |
| httpcode\_elb\_5xx\_count\_cloudwatch\_metric\_alarm\_arn | ALB 5xx count CloudWatch metric alarm ARN |
| httpcode\_elb\_5xx\_count\_cloudwatch\_metric\_alarm\_id | ALB 5xx count CloudWatch metric alarm ID |
| httpcode\_target\_3xx\_count\_cloudwatch\_metric\_alarm\_arn | ALB Target Group 3xx count CloudWatch metric alarm ARN |
| httpcode\_target\_3xx\_count\_cloudwatch\_metric\_alarm\_id | ALB Target Group 3xx count CloudWatch metric alarm ID |
| httpcode\_target\_4xx\_count\_cloudwatch\_metric\_alarm\_arn | ALB Target Group 4xx count CloudWatch metric alarm ARN |
| httpcode\_target\_4xx\_count\_cloudwatch\_metric\_alarm\_id | ALB Target Group 4xx count CloudWatch metric alarm ID |
| httpcode\_target\_5xx\_count\_cloudwatch\_metric\_alarm\_arn | ALB Target Group 5xx count CloudWatch metric alarm ARN |
| httpcode\_target\_5xx\_count\_cloudwatch\_metric\_alarm\_id | ALB Target Group 5xx count CloudWatch metric alarm ID |
| target\_response\_time\_average\_cloudwatch\_metric\_alarm\_arn | ALB Target Group response time average CloudWatch metric alarm ARN |
| target\_response\_time\_average\_cloudwatch\_metric\_alarm\_id | ALB Target Group response time average CloudWatch metric alarm ID |

<!-- markdownlint-restore -->


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | List of attributes to add to label. | list | `<list>` | no |
| aws_logs_region | The region for the AWS Cloudwatch Logs group. | string | - | yes |
| branch | Branch of the GitHub repository, e.g. master | string | - | yes |
| delimiter | The delimiter to be used in labels. | string | `-` | no |
| ecs_cluster_arn | The ECS Cluster ARN where ECS Service will be provisioned. | string | - | yes |
| ecs_cluster_name | The ECS Cluster Name to use in ECS Code Pipeline Deployment step. | string | - | yes |
| ecs_private_subnet_ids | List of Private Subnet IDs to provision ECS Service onto. | list | - | yes |
| ecs_security_group_ids | Additional Security Group IDs to allow into ECS Service. | list | `<list>` | no |
| github_oauth_token | GitHub Oauth Token with permissions to access private repositories | string | - | yes |
| listener_arns | List of ALB Listener ARNs for the ECS service. | list | - | yes |
| listener_arns_count | Number of elements in list of ALB Listener ARNs for the ECS service. | string | - | yes |
| name | Name (unique identifier for app or service) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| repo_name | GitHub repository name of the application to be built and deployed to ECS. | string | - | yes |
| repo_owner | GitHub Organization or Username. | string | - | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| tags | Map of key-value pairs to use for tags. | map | `<map>` | no |
| vpc_id | The VPC ID where resources are created. | string | - | yes |


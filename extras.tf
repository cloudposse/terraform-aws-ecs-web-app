
### Updating permissions
data "aws_iam_policy_document" "task_perms" { #UPDATE: adding some basic permissions 
  statement {
    sid = "1"

    actions = concat([
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter",
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ], var.additional_task_permissions)

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "task_perms" {
  name   = module.web_app.ecs_service_name
  path   = "/"
  policy = data.aws_iam_policy_document.task_perms.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = module.web_app.ecs_task_role_name
  policy_arn = aws_iam_policy.task_perms.arn
}

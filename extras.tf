module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "0.32.3"
  count   = var.codepipeline_enabled ? 0 : 1 #UPDATE: using this because the cp module only creates ecr when codepipeline is enabled

  attributes           = ["ecr"]
  scan_images_on_push  = var.ecr_scan_images_on_push
  image_tag_mutability = var.ecr_image_tag_mutability

  context = module.this.context
}


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

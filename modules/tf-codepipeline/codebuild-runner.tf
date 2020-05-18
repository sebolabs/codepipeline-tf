resource "aws_codebuild_project" "runner" {
  name           = "${local.codepipeline_name}-runner"
  description    = "TF runner for ${local.codepipeline_name} pipeline"
  build_timeout  = "29"
  queued_timeout = "30"

  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type                = "CODEPIPELINE"
    name                = local.codepipeline_name
    packaging           = "NONE"
    encryption_disabled = "false"
  }

  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = lookup(var.pipeline_config, "tfscaffold_runner_ecr_image_uri")
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false

    dynamic "environment_variable" {
      for_each = var.tfscaffold_vars

      content {
        name  = environment_variable.key
        value = environment_variable.value
        type  = "PLAINTEXT"
      }
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.codebuild_buildspec.rendered
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codepipeline.name
    }
  }

  tags = merge(
    local.default_tags,
    map(
      "Name", "${local.codepipeline_name}-runner",
    ),
  )
}

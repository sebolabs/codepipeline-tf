resource "aws_codebuild_project" "planner" {
  name           = "${local.codepipeline_name}-planner"
  description    = "TF planner for ${local.codepipeline_name} pipeline"
  build_timeout  = "29"
  queued_timeout = "30"

  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
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

    environment_variable {
      name  = "TF_ACTION"
      value = "plan"
      type  = "PLAINTEXT"
    }
  }

  source {
    type            = "CODECOMMIT"
    location        = data.aws_codecommit_repository.terraform.clone_url_http
    git_clone_depth = 0 # gives branch name instead of commit hash in the UI

    git_submodules_config {
      fetch_submodules = false
    }

    buildspec = data.template_file.codebuild_buildspec.rendered
  }

  source_version = "refs/heads/${lookup(var.pipeline_config, "tf_repo_branch")}"

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.codebuild_planner.name
    }
  }

  tags = merge(
    local.default_tags,
    map(
      "Name", "${local.codepipeline_name}-planner",
    ),
  )
}

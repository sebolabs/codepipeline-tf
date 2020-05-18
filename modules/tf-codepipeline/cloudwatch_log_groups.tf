resource "aws_cloudwatch_log_group" "codepipeline" {
  name  = "/aws/codepipeline/${local.codepipeline_name}"

  retention_in_days = var.cwlg_retention_in_days

  tags = merge(
    local.default_tags,
    map(
      "Name", "/aws/codepipeline/${local.codepipeline_name}",
    ),
  )
}

resource "aws_cloudwatch_log_group" "codebuild_planner" {
  name  = "/aws/codebuild/${local.codepipeline_name}-planner"

  retention_in_days = var.cwlg_retention_in_days

  tags = merge(
    local.default_tags,
    map(
      "Name", "/aws/codebuild/${local.codepipeline_name}-planner",
    ),
  )
}

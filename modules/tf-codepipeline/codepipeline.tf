resource "aws_codepipeline" "main" {
  name     = local.codepipeline_name
  role_arn = var.codepipeline_role_arn

  artifact_store {
    type     = "S3"
    location = var.codepipeline_artifacts_s3_bucket_name
  }

  stage {
    name = "Source"

    action {
      name             = "FetchCode"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      run_order        = 1
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName       = lookup(var.pipeline_config, "tf_repo_name")
        BranchName           = lookup(var.pipeline_config, "tf_repo_branch")
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "TerraformPlan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["TerraformPlanArtifacts"]

      configuration = {
        ProjectName          = aws_codebuild_project.runner.name
        EnvironmentVariables = "[{\"name\":\"TF_ACTION\",\"value\":\"plan\",\"type\":\"PLAINTEXT\"}]"
      }
    }
  }

  stage {
    name = "Gate" # TODO: SNS

    action {
      name      = "TerraformPlanApproval"
      category  = "Approval"
      owner     = "AWS"
      provider  = "Manual"
      version   = "1"
      run_order = 1

      configuration = {
        CustomData = "Do you approve the plan?"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name      = "TerraformApply"
      category  = "Build"
      owner     = "AWS"
      provider  = "CodeBuild"
      version   = "1"
      run_order = 1

      input_artifacts  = [
        "TerraformPlanArtifacts",
        "SourceArtifact",
      ]

      configuration = {
        ProjectName          = aws_codebuild_project.runner.name
        PrimarySource        = "SourceArtifact"
        EnvironmentVariables = "[{\"name\":\"TF_ACTION\",\"value\":\"apply\",\"type\":\"PLAINTEXT\"}]"
      }
    }
  }

  tags = merge(
    local.default_tags,
    map(
      "Name", "${local.codepipeline_name}",
    ),
  )
}

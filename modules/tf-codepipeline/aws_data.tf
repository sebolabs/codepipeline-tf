data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = var.codepipeline_artifacts_s3_bucket_name
}

data "template_file" "codebuild_buildspec" {
  template = file("${path.module}/templates/buildspec.tpl")

  vars = {
    tfscaffold_deployer_role_arn = var.tf_deployer_role_arn
    tfscaffold_output_plan_name  = local.codepipeline_name
  }
}

data "aws_codecommit_repository" "terraform" {
  repository_name = lookup(var.pipeline_config, "tf_repo_name")
}

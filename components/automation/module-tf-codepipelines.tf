#
# NON-PROD::AUTOMATION (self)
#
module "tf_pipeline_automation_nonprod" {
  source = "../../modules/tf-codepipeline"

  # GENERAL
  project      = var.project
  environment  = var.environment
  component    = var.component
  default_tags = local.default_tags

  # PIPELINE DETAILS
  pipeline_config = {
    tf_repo_name                    = var.codecommit_terraform_repo_name
    tf_repo_branch                  = var.codecommit_terraform_repo_main_branch
    tfscaffold_runner_ecr_repo_arn  = data.aws_ecr_repository.tfscaffold_runner.arn
    tfscaffold_runner_ecr_image_uri = var.tfscaffold_runner_ecr_image_uri
  }

  tfscaffold_vars = {
    TF_PROJECT      = var.project
    TF_ENVIRONMENT  = var.environment
    TF_COMPONENT    = var.component
    TF_STATE_BUCKET = var.tfscaffold_tfstate_bucket_prefix
    AWS_REGION      = var.aws_region
  }

  # IAM
  codepipeline_role_arn = aws_iam_role.codepipeline.arn
  tf_deployer_role_arn  = aws_iam_role.tf_deployer.arn

  # S3
  codepipeline_artifacts_s3_bucket_name = aws_s3_bucket.codepipeline.bucket
  tfscaffold_tfstate_bucket_arn         = var.tfscaffold_tfstate_bucket_arn

  # LOGS
  cwlg_retention_in_days = 7
}

#
# DEV::EXAMPLE
#
module "tf_pipeline_example_dev" {
  source = "../../modules/tf-codepipeline"

  # GENERAL
  project      = var.project
  environment  = var.environment
  component    = var.component
  default_tags = local.default_tags

  # PIPELINE DETAILS
  pipeline_config = {
    tf_repo_name                    = var.codecommit_terraform_repo_name
    tf_repo_branch                  = var.codecommit_terraform_repo_main_branch
    tfscaffold_runner_ecr_repo_arn  = data.aws_ecr_repository.tfscaffold_runner.arn
    tfscaffold_runner_ecr_image_uri = var.tfscaffold_runner_ecr_image_uri
  }

  tfscaffold_vars = {
    TF_PROJECT      = var.project
    TF_ENVIRONMENT  = "dev"
    TF_COMPONENT    = "example"
    TF_STATE_BUCKET = var.tfscaffold_tfstate_bucket_prefix
    AWS_REGION      = var.aws_region
  }

  # IAM
  codepipeline_role_arn = aws_iam_role.codepipeline.arn
  tf_deployer_role_arn  = aws_iam_role.tf_deployer.arn

  # S3
  codepipeline_artifacts_s3_bucket_name = aws_s3_bucket.codepipeline.bucket
  tfscaffold_tfstate_bucket_arn         = var.tfscaffold_tfstate_bucket_arn

  # LOGS
  cwlg_retention_in_days = 7
}

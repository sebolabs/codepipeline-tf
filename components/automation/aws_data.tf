data "aws_caller_identity" "current" {}

data "aws_codecommit_repository" "terraform" {
  repository_name = var.codecommit_terraform_repo_name
}

data "aws_ecr_repository" "tfscaffold_runner" {
  name = var.tfscaffold_runner_ecr_repo_name
}

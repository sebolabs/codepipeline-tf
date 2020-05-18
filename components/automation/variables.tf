# GENERAL
variable "aws_region" {
  type        = string
  description = "The AWS Region"
  default     = "eu-west-1"
}

variable "project" {
  type        = string
  description = "The Project name"
  default     = "lab"
}

variable "environment" {
  type        = string
  description = "The environment name"
}

variable "component" {
  type        = string
  description = "The TF component name"
  default     = "automation"
}

# SPECIFIC
variable "tfscaffold_tfstate_bucket_prefix" {
  type        = string
  description = "The TFstate S3 bucket prefix defined to be used by TFScaffold"
}

variable "tfscaffold_tfstate_bucket_arn" {
  type        = string
  description = "The TFstate S3 bucket ARN"
}

variable "tfscaffold_runner_ecr_repo_name" {
  type        = string
  description = "The name of the ECR Repository with TFScaffold Docker image"
}

variable "tfscaffold_runner_ecr_image_uri" {
  type        = string
  description = "The URI of the TFScaffold Docker image"
}

variable "codecommit_terraform_repo_name" {
  type        = string
  description = "The TF CodeCommit Terraform repo name"
}

variable "codecommit_terraform_repo_main_branch" {
  type        = string
  description = "The TF CodeCommit Terraform repo main branch"
}

# GENERAL
variable "project" {
  type        = string
  description = "The project name"
}

variable "environment" {
  type        = string
  description = "The environment name"
}

variable "component" {
  type        = string
  description = "The TF component name"
}

variable "module" {
  type        = string
  description = "The module name"
  default     = "tf-codepipeline"
}

variable "default_tags" {
  type        = map
  description = "Default tags to be applied to all taggable resources"
  default     = {}
}

# SPECIFIC
variable "pipeline_config" {
  type        = map(string)
  description = "The pipeline required properties"
}

variable "tfscaffold_vars" {
  type        = map(string)
  description = "The TFScaffold required variables"
}

variable "codepipeline_role_arn" {
  type        = string
  description = "The IAM service role for CodePipeline"
}

variable "codepipeline_artifacts_s3_bucket_name" {
  type        = string
  description = "The S3 Bucket name used to store CodePipeline artifacts"
}

variable "tf_deployer_role_arn" {
  type        = string
  description = "The TF Deployer IAM role ARN to be assumed during CodeBuild run"
}

variable "cwlg_retention_in_days" {
  type        = string
  description = "Specifies the number of days you want to retain log events"
}

variable "tfscaffold_tfstate_bucket_arn" {
  type        = string
  description = "The ARN of the TFScaffold TFstate S3 bucket"
}

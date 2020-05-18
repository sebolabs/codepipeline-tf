#
# GENERAL
#
environment = "nonprod"

#
# AUTOMATION
#
tfscaffold_tfstate_bucket_prefix = "tf-sebolabs"
tfscaffold_tfstate_bucket_arn    = "arn:aws:s3:::tf-sebolabs-012345678910-eu-west-1"

tfscaffold_runner_ecr_repo_name = "tfscaffold"
tfscaffold_runner_ecr_image_uri = "012345678910.dkr.ecr.eu-west-1.amazonaws.com/tfscaffold:latest"

codecommit_terraform_repo_name        = "terraform"
codecommit_terraform_repo_main_branch = "master"

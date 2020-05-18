data "aws_iam_policy_document" "codebuild_assumerole" {
  statement {
    sid    = "AllowCodeBuildAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "codebuild.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${local.codepipeline_name}-codebuild"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assumerole.json

  tags = merge(
    local.default_tags,
    map(
      "Name", "${local.codepipeline_name}/codebuild",
    ),
  )
}

data "aws_iam_policy_document" "codebuild" {
  statement {
    sid    = "AllowLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "${aws_cloudwatch_log_group.codepipeline.arn}:*",
      "${aws_cloudwatch_log_group.codebuild_planner.arn}:*",
    ]
  }

  statement {
    sid    = "AllowS3"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
    ]

    resources = [
      data.aws_s3_bucket.codepipeline_artifacts.arn,
      "${data.aws_s3_bucket.codepipeline_artifacts.arn}/*",
      var.tfscaffold_tfstate_bucket_arn,
      "${var.tfscaffold_tfstate_bucket_arn}/*",
    ]
  }

  statement {
    sid    = "AllowECR"
    effect = "Allow"

    actions = [
      "ecr:List*",
      "ecr:Describe*",
      "ecr:*Get*",
    ]

    resources = [
      lookup(var.pipeline_config, "tfscaffold_runner_ecr_repo_arn"),
    ]
  }

  statement {
    sid    = "AllowCodeCommit"
    effect = "Allow"

    actions = [
      "codecommit:GitPull",
    ]

    resources = [
      data.aws_codecommit_repository.terraform.arn,
    ]
  }

  statement {
    sid    = "AllowStsAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    resources = [
      var.tf_deployer_role_arn,
    ]
  }
}

resource "aws_iam_policy" "codebuild" {
  name        = "${local.codepipeline_name}-codebuild"
  description = "CodeBuild (${upper(local.codepipeline_name)}) access policy"
  policy      = data.aws_iam_policy_document.codebuild.json
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild.arn
}

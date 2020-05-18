data "aws_iam_policy_document" "codepipeline_assumerole" {
  statement {
    sid    = "AllowCodePipelineAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "codepipeline.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = "${local.aws_account_level_id}-codepipeline"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assumerole.json

  tags = merge(
    local.default_tags,
    map(
      "Name", "${local.aws_account_level_id}/codepipeline",
    ),
  )
}

data "aws_iam_policy_document" "codepipeline" {
  statement {
    sid    = "AllowS3"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.codepipeline.arn,
      "${aws_s3_bucket.codepipeline.arn}/*"
    ]
  }

  statement {
    sid    = "AllowCodeCommit"
    effect = "Allow"

    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive",
    ]

    resources = [
      data.aws_codecommit_repository.terraform.arn,
    ]
  }

  statement {
    sid    = "AllowCodeBuild"
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds", # TODO: *
      "codebuild:StartBuild",     # TODO: specific
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowECR"
    effect = "Allow"

    actions = [
      "ecr:DescribeImages",
    ]

    resources = [
      data.aws_codecommit_repository.terraform.arn
    ]
  }
}

resource "aws_iam_policy" "codepipeline" {
  name        = "${local.aws_account_level_id}-codepipeline"
  description = "CodePipeline (${upper(local.aws_account_level_id)}) access policy"
  policy      = data.aws_iam_policy_document.codepipeline.json
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = aws_iam_policy.codepipeline.arn
}

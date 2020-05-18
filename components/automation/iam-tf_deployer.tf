#
# The IAM Role defined here to be used by TF pipelines is just a simplification.
# Ideally, IAM permissions should be crafted in a secure way.
# When deploying to different accounts, roles from those accounts should be used.
#
data "aws_iam_policy_document" "tf_deployer_assumerole" {
  statement {
    sid    = "AllowCodeBuildDockerAssumeRole"
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "AWS"

      identifiers = [
        data.aws_caller_identity.current.account_id,
      ]
    }
  }
}

resource "aws_iam_role" "tf_deployer" {
  name               = "${local.aws_account_level_id}-tf-deployer"
  assume_role_policy = data.aws_iam_policy_document.tf_deployer_assumerole.json

  tags = merge(
    local.default_tags,
    map(
      "Name", "${local.aws_account_level_id}/tf-deployer",
    ),
  )
}

resource "aws_iam_role_policy_attachment" "tf_deployer" {
  role       = aws_iam_role.tf_deployer.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

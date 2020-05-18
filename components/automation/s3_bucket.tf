resource "aws_s3_bucket" "codepipeline" {
  bucket = "${local.aws_global_level_id}-codepipeline-artifacts"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(
    local.default_tags,
    map(
      "Name", "${local.aws_global_level_id}-codepipeline-artifacts",
    ),
  )
}

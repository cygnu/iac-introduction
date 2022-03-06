data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.this.arn]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::my-s3-bucket/",
    ]
  }
}

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.14.1"
  # insert the 5 required variables here

  bucket = "my-s3-bucket"
  acl    = "public-read"

  policy = data.aws_iam_policy_document.bucket_policy.json

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  versioning = {
    enabled = true
  }

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = false
}

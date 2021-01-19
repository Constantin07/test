terraform {
  required_version = ">= 0.14"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.24.1"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  tags = {
    "account"     = data.aws_caller_identity.current.account_id
    "environment" = var.account_name
  }
}

data "aws_caller_identity" "current" {
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.account_name}-${data.aws_caller_identity.current.account_id}-terraform-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.tags
}

data "aws_iam_policy_document" "default" {
  statement {
    sid = "DenyIncorrectEncryptionHeader"

    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "AES256",
      ]
    }
  }

  statement {
    sid = "DenyUnEncryptedObjectUploads"

    effect = "Deny"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"

      values = [
        "true",
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.default.json
}

resource "aws_s3_bucket_public_access_block" "this" {
  depends_on = [aws_s3_bucket_policy.this]

  bucket              = aws_s3_bucket.this.id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_dynamodb_table" "this" {
  name           = "terraform-lock"
  read_capacity  = "1"
  write_capacity = "1"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = false
  }

  tags = local.tags
}

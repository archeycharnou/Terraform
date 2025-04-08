
#####################################
# S3 BUCKET
#####################################

resource "aws_s3_bucket" "private_docs_bucket" {
  bucket = "private-docs-bucket"

  force_destroy = false # CAREFUL! Allows bucket deletion even if objects exist

  tags = {
    Name = "PrivateDocsBucket"
  }
}

# Apply Server Side S3 Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "private_docs_encryption" {
  bucket = aws_s3_bucket.private_docs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block Public Access to S3
resource "aws_s3_bucket_public_access_block" "private_docs_block" {
  bucket = aws_s3_bucket.private_docs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Restrict Access Only Through The Role
resource "aws_s3_bucket_policy" "private_docs_policy" {
  bucket = aws_s3_bucket.private_docs_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowAccessFromIAMRoleOnly",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.s3_access_role.arn
        },
        Action = "s3:*",
        Resource = [
          "${aws_s3_bucket.private_docs_bucket.arn}",
          "${aws_s3_bucket.private_docs_bucket.arn}/*"
        ]
      }
    ]
  })
}

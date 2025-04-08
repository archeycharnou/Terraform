
#####################################
# IAM ROLE FOR ACCESSING PRIVATE S3
#####################################

resource "aws_iam_role" "s3_access_role" {
  name = "s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


#####################################
# IAM ROLE POLICY FOR ACCESSING PRIVATE S3
#####################################

resource "aws_iam_policy" "s3_access_policy" {
  name        = "-s3-access-policy"
  description = "Policy to allow access to private docs bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.private_docs_bucket.arn}",
          "${aws_s3_bucket.private_docs_bucket.arn}/*"
        ]
      }
    ]
  })
}

#####################################
# Attachhing policy to role
#####################################

resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}


#####################################
# IAM Instance Profile
#####################################

resource "aws_iam_instance_profile" "s3_access_instance_profile" {
  name = "s3-access-profile"
  role = aws_iam_role.s3_access_role.name
}



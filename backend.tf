# Allows for you to name the bucket and dynamoDB table on creation
variable "s3_bucket_name" {}
variable "dynamo_db_table_name" {}

/*
## UNCOMMENT AFTER INITIAL APPLY
## run : terraform init -reconfigure AFTER the apply to reconfigure to remote backend


terraform {
  required_version = ">=0.12.13"
  backend "s3" {
    bucket         = "<name of bucket>"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "<name of DynamoDB>"
    encrypt        = true
  }
}
*/

##
# Module to Build the DevOps Remote State Configuration
##

# Build an S3 bucket to store TF state
resource "aws_s3_bucket" "state_bucket" {
  bucket = var.s3_bucket_name
  force_destroy = false

  # Tells AWS to encrypt the S3 bucket at rest by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Prevents Terraform from destroying or replacing this object
  lifecycle {
    prevent_destroy = true
  }

  # Tells AWS to keep a version history of the state file
  versioning {
    enabled = true
  }

  tags = {
    Terraform = "true"
  }
}

# Prevent public access to the bucket
resource "aws_s3_bucket_public_access_block" "state_bucket_block" {
  bucket = aws_s3_bucket.state_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}


# Build a DynamoDB to use for terraform state locking
resource "aws_dynamodb_table" "tf_lock_state" {
  name = var.dynamo_db_table_name

  # Pay per request is cheaper for low-i/o applications, like our TF lock state
  billing_mode = "PAY_PER_REQUEST"

  # Hash key is required, and must be an attribute
  hash_key = "LockID"

  # Attribute LockID is required for TF to use this table for lock state
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = var.dynamo_db_table_name
    BuiltBy = "Terraform"
  }
}

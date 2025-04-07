/*
RUN AFTER RESOURCE CREATION ITSELF, comment out resource creation after

terraform {
  required_version = ">=0.12.13"
  backend "s3" {
    bucket         = "tf-state"
    key            = "terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "aws-locks"
    encrypt        = true
  }
}
*/

##
# Module to build the DevOps "seed" configuration
##

# Build an S3 bucket to store TF state
resource "aws_s3_bucket" "state_bucket" {
  bucket = var.s3_bucket_name

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
    # Key = Value 
  }
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

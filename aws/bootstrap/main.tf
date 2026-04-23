terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random ={
      source  = "hashicorp/random"
      version = "~> 3.6"

    }
  }

}

provider "aws" {
  region = "eu-central-1"
  profile = "lync"
}

# generate a random id to append to the bucket name
resource "random_id" "devops_wiki_randomid" {
  byte_length = 8
}

# s3 bucket for remote state management 
resource "aws_s3_bucket" "devops_wiki_tf_state" {
  bucket = "devops-wiki-tf-state-bucket--${random_id.devops_wiki_randomid.hex}"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "DevOps WiKi Terraform State"
    ManagedBy   = "terraform"
  }
}

# enable bucket versioning
resource "aws_s3_bucket_versioning" "devops_wiki_tf_state_versioning" {
  bucket = aws_s3_bucket.devops_wiki_tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# encrypt the state files
resource "aws_s3_bucket_server_side_encryption_configuration" "devops_wiki_tf_state_encryption" {
  bucket = aws_s3_bucket.devops_wiki_tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# block public access to the bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.devops_wiki_tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
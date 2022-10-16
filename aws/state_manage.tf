#Create backend resource for saving state data

resource "aws_dynamodb_table" "tf_state" {
    name            = "tf_state_db_table"
    billing_mode    = "PROVISIONED"
    read_capacity   = 5
    write_capacity  = 5
    hash_key        = "UserId"
    attribute {
      name = "UserId"
      type = "S"
    }
    tags = {
      "Name" = "table_tf_state"
      "Description" = "table for save lock state tf data"
    }
}

resource "aws_kms_key" "s3_kms_encryption_key" {
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "tf_state" {
  bucket = var.s3_tf_bucket_name
  versioning {
    enabled = true
  }
  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_kms_encryption_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    "Name" = "s3_tf_state"
    "Description" = "s3 for  save lock state tf files"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_tf_access" {
    bucket = aws_s3_bucket.tf_state.id
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}

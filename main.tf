resource "aws_s3_bucket" "cbucket2022" {
  bucket = var.bucket-name
  acl    = "private"
  
   server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_iam_role" "role" {
    name = "s3role"
    assume_role_policy = data.aws_iam_policy_document.s3policydoc.json
    inline_policy {
      policy = data.aws_iam_policy_document.source.json
    }
}

data "aws_iam_policy_document" "s3policydoc" {
    statement {
      actions = ["sts:AssumeRole"]

      principals {
          type = "Service"
          identifiers = ["s3.amazonaws.com"]
      }
    }
  
}

data "aws_iam_policy_document" "source" {
  statement {
      sid = "s3 get and put"
      effect = "Allow"
      actions = [ 
          "s3:Get*",
          "s3:put*",
          "s3:List*"
       ]
       resources = ["rn:aws:s3:::cbucket2022/*"]
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

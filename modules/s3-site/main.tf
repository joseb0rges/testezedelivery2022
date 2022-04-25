resource "aws_s3_bucket" "mybucket" {
  bucket = "${var.bucket_name}"
  acl    = "private"
  versioning {
    enabled = false
  }
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
 
 tags = {
    environment = lab
    owner = "Jose Borges"
    LabID = "98981602022"
  }
  
}

#Upload files of your static website

resource "aws_s3_bucket_object" "html" {
  for_each = fileset("website/", "**/*.html")

  bucket = aws_s3_bucket.mybucket.bucket
  key    = each.value
  source = "website/${each.value}"
  etag   = filemd5("website/${each.value}")
  content_type = "text/html"
}

# Print the files processed so far
output "fileset-results" {
  value = fileset("website/", "**/*")
}

locals {
  s3_origin_id = "${var.bucket_name}"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${var.bucket_name}"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = true
  block_public_policy     = true

}




#######################################################################################
# Bucket: staging
#######################################################################################
resource "aws_s3_bucket" "staging_class" {
  bucket        = "${var.bucket}"
  force_destroy = true

  tags = {
    Name = "${var.bucket}"
  }
}

resource "aws_s3_bucket_ownership_controls" "staging_class" {
  bucket = aws_s3_bucket.staging_class.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [
    aws_s3_bucket.staging_class,
  ]
}

resource "aws_s3_bucket_acl" "staging_class" {
  bucket = aws_s3_bucket.staging_class.id
  acl    = "private"
  depends_on = [
    aws_s3_bucket_ownership_controls.staging_class,
  ]
}

resource "aws_s3_object" "staging_file" {
  bucket     = aws_s3_bucket.staging_class.bucket
  key        = "secretplans.txt"
  source     = "${path.module}/files/aviata/secretplans.txt"
  etag       = filemd5("${path.module}/files/aviata/secretplans.txt")
  depends_on = [aws_s3_bucket.staging_class]
}
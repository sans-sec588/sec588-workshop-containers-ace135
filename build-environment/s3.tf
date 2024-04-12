#######################################################################################
# Bucket: aviata
#######################################################################################
resource "aws_s3_bucket" "staging_class" {
  bucket        = var.bucket
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

#######################################################################################
# Bucket: dev site
#######################################################################################
resource "aws_s3_bucket" "dev_site" {
  bucket = "dev.aviata.com"
}

#resource "aws_s3_bucket_policy" "dev_site" {
#  bucket = aws_s3_bucket.dev_site.id
#  policy = jsonencode(
#    {
#      "Version" : "2012-10-17",
#      "Statement" : [
#        {
#          "Sid" : "PublicReadGetObject",
#          "Effect" : "Allow",
#          "Principal" : "*",
#          "Action" : "s3:GetObject",
#          "Resource" : "arn:aws:s3:::${aws_s3_bucket.dev_site.id}/*"
#        }
#      ]
#    }
#  )
#}

resource "aws_s3_object" "dev_site" {
  for_each     = fileset(path.module, "files/content/**/*.{html,css,js}")
  bucket       = aws_s3_bucket.dev_site.id
  key          = replace(each.value, "files/^content//", "")
  source       = each.value
  content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
  etag         = filemd5(each.value)
}

resource "aws_s3_bucket_website_configuration" "dev_site" {
  bucket = aws_s3_bucket.dev_site.id

  index_document {
    suffix = "index.html"
  }
}

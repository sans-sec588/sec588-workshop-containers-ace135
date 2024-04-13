#######################################################################################
# Pull in the existing Route53 Data from the domain. 
#######################################################################################
data "aws_route53_zone" "aviata" {
  name = var.domain # This will be populated by either the default value or 
}

#######################################################################################
# AWS Route53 Record for the Dev Site
#######################################################################################
resource "aws_route53_record" "dev" {
  zone_id = data.aws_route53_zone.aviata.zone_id
  name    = "dev.${data.aws_route53_zone.aviata.name}" # This will come from the data element above
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_s3_bucket_website_configuration.dev_site.website_endpoint}"] # This is the dev S3 Bucket
}

resource "aws_route53_record" "dvo" {
  for_each = {
    for dvo in aws_acm_certificate.dev.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.aviata.zone_id
}
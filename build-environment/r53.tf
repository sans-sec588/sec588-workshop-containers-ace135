data "aws_route53_zone" "aviata" {
  name = var.domain
}

resource "aws_route53_record" "dev" {
  zone_id = data.aws_route53_zone.aviata.zone_id
  name    = "dev.${data.aws_route53_zone.aviata.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_s3_bucket_website_configuration.dev_site.website_endpoint}"]
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
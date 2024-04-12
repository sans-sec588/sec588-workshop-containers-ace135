# We only need this to populate SubFinder, Subfinder is a required component of our lab, this is for Ceritificate Transparency Only.

resource "aws_acm_certificate" "dev" {
  domain_name       = "dev.${var.domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "dev" {
  certificate_arn         = aws_acm_certificate.dev.arn
  validation_record_fqdns = [for record in aws_route53_record.dvo : record.fqdn]
}
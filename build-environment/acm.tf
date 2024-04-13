#######################################################################################
# This is for crt.sh to have a certificate to point students to (dev.${var.domain})
#######################################################################################
resource "aws_acm_certificate" "dev" {
  domain_name       = "dev.${var.domain}" # This is for subfinder
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "dev" {
  certificate_arn         = aws_acm_certificate.dev.arn
  validation_record_fqdns = [for record in aws_route53_record.dvo : record.fqdn] # Look at R53 for this information
}
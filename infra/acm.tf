# ACM Certificate Resource
resource "aws_acm_certificate" "kts_cert" {
    
  domain_name = "kts-backend.kavindu-gihan.tech"
  subject_alternative_names = [
    "kts-admin.kavindu-gihan.tech",
    "kts-user.kavindu-gihan.tech"
  ]

  validation_method = "DNS"

  tags = {
    name         = "kavindu-gihan-tech-cert"
    project_name = local.project_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

# DNS Validation Record
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.kts_cert.domain_validation_options : dvo.domain_name => dvo
  }

  allow_overwrite = true
  name            = each.value.resource_record_name
  records         = [each.value.resource_record_value]
  ttl             = 60
  type            = each.value.resource_record_type
  zone_id         = aws_route53_zone.kts-hosted-zone.zone_id
}

# # Certificate Validation
resource "aws_acm_certificate_validation" "kts_cert_validation" {
  certificate_arn = aws_acm_certificate.kts_cert.arn

  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation :
    record.fqdn
  ]
}

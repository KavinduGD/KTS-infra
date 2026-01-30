output "hosted_zone_name_server" {
  value = aws_route53_zone.kts-hosted-zone.name_servers
}

output "certs_dns_dvo" {
  value = {
    for dvo in aws_acm_certificate.kts_cert.domain_validation_options : dvo.domain_name => dvo
  }
  sensitive = true
}



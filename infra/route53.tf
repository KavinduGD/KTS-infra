resource "aws_route53_zone" "kts-hosted-zone" {
  name = "kavindu-gihan.tech"

  tags = {
    project_name = local.project_name
  }
}



resource "aws_route53_record" "backend" {
  zone_id = aws_route53_zone.kts-hosted-zone.zone_id
  name    = "kts-backend.kavindu-gihan.tech"
  type    = "A"

  alias {
    name                   = aws_lb.depl_lb.dns_name
    zone_id                = aws_lb.depl_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "user" {
  zone_id = aws_route53_zone.kts-hosted-zone.zone_id
  name    = "kts-user.kavindu-gihan.tech"
  type    = "A"

  alias {
    name                   = aws_lb.depl_lb.dns_name
    zone_id                = aws_lb.depl_lb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "admin" {
  zone_id = aws_route53_zone.kts-hosted-zone.zone_id
  name    = "kts-admin.kavindu-gihan.tech"
  type    = "A"

  alias {
    name                   = aws_lb.depl_lb.dns_name
    zone_id                = aws_lb.depl_lb.zone_id
    evaluate_target_health = true
  }
}

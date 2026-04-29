# hosted zone
resource "aws_route53_zone" "devopswiki-hosted-zone" {
  name    = "devopswiki.info"
}

# dns record 
resource "aws_route53_record" "devopswiki-dns-recods" {
  zone_id = aws_route53_zone.devopswiki-hosted-zone.zone_id
  name    = "devopswiki.info"
  type    = "A"
  ttl     = "300"
  records = [var.fe_eip]
}

resource "aws_route53_record" "devopswiki-www-dns-record" {
  zone_id = aws_route53_zone.devopswiki-hosted-zone.zone_id
  name    = "www.devopswiki.info"
  type    = "A"
  ttl     = "300"
  records = [var.fe_eip]
}
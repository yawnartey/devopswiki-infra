output "nameservers" {
  value = aws_route53_zone.devopswiki-hosted-zone.name_servers
}
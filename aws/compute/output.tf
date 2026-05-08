output "fe_eip" {
  value = aws_eip.devopswiki-fe-eip.public_ip
}
output "be_pip" {
  value = aws_eip.devopswiki-fe-eip.private_ip
}

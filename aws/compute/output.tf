output "fe_eip" {
  value = aws_eip.devopswiki-fe-eip.public_ip
}
output "be_pip" {
  value = aws_instance.devopswiki-be.private_ip
}

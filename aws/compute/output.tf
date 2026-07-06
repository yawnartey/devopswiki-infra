output "fe_pip" {
  value = aws_instance.devopswiki-fe.public_ip
}
output "be_pip" {
  value = aws_instance.devopswiki-be.private_ip
}
output "be_public_ip" {
  value = aws_instance.devopswiki-be.public_ip
}

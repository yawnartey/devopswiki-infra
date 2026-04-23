output "vpc_id" {
  value = aws_vpc.devopswiki-vpc.id
}
output "subnet_ids" {
  value = {
    "fe-subnet" = aws_subnet.fe-subnet.id
    "be-subnet" = aws_subnet.be-subnet.id
  }
}
# frontend ec2 instance
resource "aws_instance" "devopswiki-fe" {
  ami                    = "ami-023adbbb2c440f837"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_ids["fe-subnet"]
  vpc_security_group_ids = [var.fe_security_group_id]
  user_data = templatefile("${path.module}/scripts/bootstrap-fe.sh", {
    yaw_public_key     = var.yaw_public_key
    postgres_user      = var.postgres_user
    postgres_password  = var.postgres_password
    github_token       = var.github_token
    dockerhub_username = var.dockerhub_username
    dockerhub_password = var.dockerhub_password
  })
  tags = {
    Name = "DevOps WiKi Frontend"
  }
}

# backend ec2 instance
resource "aws_instance" "devopswiki-be" {
  ami                    = "ami-023adbbb2c440f837"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_ids["be-subnet"]
  vpc_security_group_ids = [var.be_security_group_id]
  user_data = templatefile("${path.module}/scripts/bootstrap-be.sh", {
    be_private_ip      = aws_instance.devopswiki-be.private_ip
    yaw_public_key     = var.yaw_public_key
    postgres_user      = var.postgres_user
    postgres_password  = var.postgres_password
    github_token       = var.github_token
    dockerhub_username = var.dockerhub_username
    dockerhub_password = var.dockerhub_password

  })
  tags = {
    Name = "DevOps WiKi Backend"
  }
}

# frontend eip
resource "aws_eip" "devopswiki-fe-eip" {
  domain   = "vpc"
  instance = aws_instance.devopswiki-fe.id
  tags     = { Name = "DevOps WiKi FE EIP" }
}

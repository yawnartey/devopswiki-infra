locals {
  user_data = <<-EOF
    #!/bin/bash
    useradd -m -s /bin/bash yaw
    mkdir -p /home/yaw/.ssh
    chmod 700 /home/yaw/.ssh
    echo "${var.yaw_public_key}" > /home/yaw/.ssh/authorized_keys
    chmod 600 /home/yaw/.ssh/authorized_keys
    chown -R yaw:yaw /home/yaw/.ssh
    echo "yaw ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/yaw
    chmod 440 /etc/sudoers.d/yaw
  EOF
}

# frontend ec2 instance
resource "aws_instance" "devopswiki-fe" {
  ami                    = "ami-023adbbb2c440f837"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_ids["fe-subnet"]
  vpc_security_group_ids = [var.fe_security_group_id]
  user_data = local.user_data
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
  user_data = local.user_data
  tags = {
    Name = "DevOps WiKi Backend"
  }
}

# frontend eip
resource "aws_eip" "devopswiki-fe-eip" {
  domain   = "vpc"
  instance = aws_instance.devopswiki-fe.id
  tags = { Name = "DevOps WiKi FE EIP" }
}

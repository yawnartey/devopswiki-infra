# vpc
resource "aws_vpc" "devopswiki-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "DevOps WiKi VPC"
  }
}

# internet gateway
resource "aws_internet_gateway" "devopswiki-igw" {
  vpc_id = aws_vpc.devopswiki-vpc.id
  tags = {
    Name = "DevOps WiKi IGW"
  }
}

# frontend public subnet 
resource "aws_subnet" "fe-subnet" {
  vpc_id                  = aws_vpc.devopswiki-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "DevOps WiKi FE Subnet"
  }
}

# backend private subnet, now public subnet
resource "aws_subnet" "be-subnet" {
  vpc_id                  = aws_vpc.devopswiki-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "DevOps WiKi BE Subnet"
  }
}

# elastic ip for nat gateway. removed now, relying on public subnet to save cost
# resource "aws_eip" "devopswiki-nat-eip" {
#   domain = "vpc"
#   tags = {
#     Name = "DevOps WiKi NAT EIP"
#   }
# }

# nat gateway - in fe-subnet for be-subnet outbound internet. removed now, relying on public subnet to save cost
# resource "aws_nat_gateway" "devopswiki-nat" {
#   allocation_id = aws_eip.devopswiki-nat-eip.id
#   subnet_id     = aws_subnet.fe-subnet.id
#   tags = {
#     Name = "DevOps WiKi NAT"
#   }
# }

# public route table for fe-subnet
resource "aws_route_table" "fe-route-table" {
  vpc_id = aws_vpc.devopswiki-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devopswiki-igw.id
  }
  tags = {
    Name = "DevOps WiKi FE RT"
  }
}

# private route table for be-subnet. now public route table
resource "aws_route_table" "be-route-table" {
  vpc_id = aws_vpc.devopswiki-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devopswiki-igw.id
  }
  tags = {
    Name = "DevOps WiKi BE RT"
  }
}

# fe-subnet association to public route table
resource "aws_route_table_association" "fe-rt-association" {
  subnet_id      = aws_subnet.fe-subnet.id
  route_table_id = aws_route_table.fe-route-table.id
}

# be-subnet association to private route table
resource "aws_route_table_association" "be-rt-association" {
  subnet_id      = aws_subnet.be-subnet.id
  route_table_id = aws_route_table.be-route-table.id
}

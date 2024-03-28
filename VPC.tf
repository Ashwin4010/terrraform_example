terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}
resource "aws_vpc" "bruh_VPC" {
  cidr_block       = "123.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "bruh_VPC"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.bruh_VPC.id
  cidr_block = "123.0.1.0/24"
  availability_zone="ap-south-1b"
  tags = {
    Name = "public subnet bruh"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.bruh_VPC.id
  cidr_block = "123.0.2.0/24"
  availability_zone="ap-south-1b"
  tags = {
    Name = "private subnet bruh"
  }
}
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.bruh_VPC.id

  tags = {
    Name = "internet-gateway"
  }
}
resource "aws_eip" "my_eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "my_nat_gw" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "my_nat_gw"
  }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.bruh_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "public_route_table"
  }
}
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.bruh_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gw.id
  }

  tags = {
    Name = "private_route_table"
  }
}
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_security_group" "public_sg" {
  name        = "allow_web"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.bruh_VPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public security group for bruh vpc"
  }
}
resource "aws_security_group" "private_sg" {
  name        = "private sg"
  description = "Allow TLS inbound traffic from public subnet"
  vpc_id      = aws_vpc.bruh_VPC.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["123.0.1.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private security group for bruh vpc"
  }
}
resource "aws_instance" "bruh_public_instance" {
  ami                                             = "ami-007020fd9c84e18c7"
  instance_type                                   = "t2.micro"
  availability_zone                               = "ap-south-1a"
  associate_public_ip_address                     = "true"
  vpc_security_group_ids                          = [aws_security_group.public_sg.id]
  subnet_id                                       = aws_subnet.public_subnet.id
  key_name                                        = "jenkins_2"

    tags = {
    Name = "public instance"
  }
}
resource "aws_instance" "bruh_private_instance" {
  ami                                             = "ami-007020fd9c84e18c7"
  instance_type                                   = "t2.micro"
  availability_zone                               = "ap-south-1a"
  associate_public_ip_address                     = "false"
  vpc_security_group_ids                          = [aws_security_group.private_sg.id]
  subnet_id                                       = aws_subnet.private_subnet.id
  key_name                                        = "jenkins_2"

    tags = {
    Name = "private instance"
  }
}

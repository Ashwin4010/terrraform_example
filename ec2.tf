terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "Terraform_instance" {
  ami           = "ami-007020fd9c84e18c7"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0fc24d3949e171bcf"
  security_groups = ["sg-0e272864109ba6399"]

  tags = {
    Name = "my_Terra_instance"
  }
}

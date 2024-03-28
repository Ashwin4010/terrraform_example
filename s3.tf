terraform {
    required_providers {
      aws = {
        source  = "hashicorp/aws"
        version = "5.19.0"  # Use the latest version
      }
    }
  }
provider "aws" {
    region = "ap-south-1"  # Replace with your desired AWS region
  }

resource "aws_s3_bucket" "terra_ashwin_sample" {
  bucket = "super-unique-bucket-name-by-ashwin4010"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

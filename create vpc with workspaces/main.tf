provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "ivanfan" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${terraform.workspace}-vpc"
  }
}

resource "aws_subnet" "ivanfan_subnet" {
  vpc_id                  = aws_vpc.ivanfan.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${terraform.workspace}-subnet"
  }
}

output "vpc_id" {
  value = aws_vpc.ivanfan.id
}

output "subnet_id" {
  value = aws_subnet.ivanfan_subnet.id
}
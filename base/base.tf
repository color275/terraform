provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "my_public_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "my_public_subnet_c" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "my_private_subnet_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-northeast-2a"
}

resource "aws_subnet" "my_private_subnet_c" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-northeast-2c"
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = "YourElasticIPAllocationIdForAZa"
  subnet_id     = aws_subnet.my_public_subnet_a.id
}

resource "aws_nat_gateway" "nat_gateway_c" {
  allocation_id = "YourElasticIPAllocationIdForAZc"
  subnet_id     = aws_subnet.my_public_subnet_c.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.my_public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_c_association" {
  subnet_id      = aws_subnet.my_public_subnet_c.id
  route_table_id = aws_route_table.public_route_table.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.my_vpc.id
}

output "public_subnet_a_id" {
  description = "Public Subnet A ID"
  value       = aws_subnet.my_public_subnet_a.id
}

output "public_subnet_c_id" {
  description = "Public Subnet C ID"
  value       = aws_subnet.my_public_subnet_c.id
}

output "private_subnet_a_id" {
  description = "Private Subnet A ID"
  value       = aws_subnet.my_private_subnet_a.id
}

output "private_subnet_c_id" {
  description = "Private Subnet C ID"
  value       = aws_subnet.my_private_subnet_c.id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.my_igw.id
}

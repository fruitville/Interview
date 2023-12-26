provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr_blocks[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_launch_template" "example" {
  name = "example_template"

  version = "Latest" 

  image_id = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
}

resource "aws_autoscaling_group" "example" {
  desired_capacity     = 1
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier = aws_subnet.private[*].id

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"  
  }
}

resource "aws_instance" "web_server" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = element(aws_subnet.public[*].id, 0)
  key_name        = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "Web Server"
  }
}

resource "aws_instance" "database_server" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = element(aws_subnet.private[*].id, 0)
  key_name      = var.key_name

  tags = {
    Name = "Database Server"
  }
}


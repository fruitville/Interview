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

resource "aws_launch_template" "maintemp" {
  name = "maintemp_template"

  version = "Latest" 

  image_id = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
}

resource "aws_security_group" "jenkins-sg-2023" {
  name        = "var.security_group"
  description = "security group for jenkins"
  vpc_id      = aws_vpc.main.id


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

 # outbound from Jenkins server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags= {
    Name = var.security_group
  }
}

resource "aws_autoscaling_group" "mainasg" {
  desired_capacity     = 4
  max_size             = 6
  min_size             = 2
  vpc_zone_identifier = aws_subnet.private[*].id

  launch_template {
    id      = aws_launch_template.example.id
    version = "Latest"  
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


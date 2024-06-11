resource "aws_vpc" "vpc-app" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet-app-public" {
  vpc_id = aws_vpc.vpc-app.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet-app-private" {
  vpc_id = aws_vpc.vpc-app.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_security_group" "db-sg" {
  vpc_id = aws_vpc.vpc-app.id

  ingress {
    from_port   = 3306 
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["127.0.0.1/32"] 
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

data "aws_availability_zones" "available" {}

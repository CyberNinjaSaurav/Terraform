provider "aws" {
  region = "us-east-1" 
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "web_server" {
  ami                  = "ami-01e3c4a339a264cc9"  # Use a BIOS-compatible AMI
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]  # ✅ Fix applied

  tags = {
    Name = "Terraform-EC2"
  }
}


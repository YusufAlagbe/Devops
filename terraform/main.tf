provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow web + SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["18.217.141.221/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.main.id
}

resource "aws_instance" "app" {
  ami             = "ami-0c7217cdde317cfec" # Amazon Linux 2023
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public.id
  security_groups = [aws_security_group.web_sg.id]
  key_name        = "your-key-name"
}

resource "aws_db_instance" "rds" {
  allocated_storage   = 20
  engine              = "mysql"
  instance_class      = "db.t3.micro"
  db_name             = "contactdb"
  username            = "admin"
  password            = "Obatala123#"
  publicly_accessible = true
  skip_final_snapshot = true
}

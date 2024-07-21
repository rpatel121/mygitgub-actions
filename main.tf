data "aws_ami" "this" {
  most_recent = true

filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Canonical
}


data "aws_vpc" "default" {
  default = true
}


resource "aws_instance" "web" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_https.id]
  user_data              = file("user_data.sh")

  tags = {
    Name = "MyEC2Instance"
  }
}

resource "aws_security_group" "allow_https" {
  name        = "allow_tls"
  description = "Allow https inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_https"
  }
}



output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "web_sg" {
  name = "allow_http"

  ingress {
    description = "Allow HTTP"
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
}

resource "aws_instance" "web_server" {
  ami           = "ami-0f5ee92e2d63afc18"  # Amazon Linux 2 (ap-south-1)
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              cat <<EOT > /var/www/html/index.html
              ${file("index.html")}
              EOT
              EOF

  tags = {
    Name = "SimpleHTMLServer"
  }
}

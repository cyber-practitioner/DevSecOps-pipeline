#First EC2 instance will contain github clone of netflix and SAST tools installed

provider "aws" {
  region = "us-east-1"
  profile = "project"
}

resource "aws_instance" "test-instance" {
  ami           = "ami-06aa3f7caf3a30282"
  instance_type = "t2.large"
  vpc_security_group_ids = [aws_security_group.Jenkins-sg.id]
  user_data = "${file("script.sh")}"

  tags = {
    Name = "Jenkins"
}
}

resource "aws_security_group" "Jenkins-sg" {
  name        = "jenkins-sg"
  description = "Allow inbound SSH and other traffic"
  vpc_id      = "vpc-0fc26fe53d6c17730" # Replace with your VPC ID

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

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    description = "App_port"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    description = "Jenkins"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_eip" "demo_eip" {
  vpc = true
  instance= aws_instance.test-instance.id

}


resource "aws_security_group_rule" "allow_outbound" {
  security_group_id = aws_security_group.Jenkins-sg.id

  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
}
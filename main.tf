provider "aws" {
  region = "us-east-1"
  profile = "project"
}

resource "aws_instance" "test-instance" {
  ami           = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.large"
  Name = "jenkins-instance"
}


resource "aws_instance" "monitoring-instance" {
  ami           = "ami-06aa3f7caf3a30282"
  instance_type = "t2.medium"
  vpc_security_group_ids = [aws_security_group.monitoring.id]
  user_data = "${file("monitoring-script.sh")}"

  tags = {
    Name = "Monitoring-server"
}
}

resource "aws_security_group" "monitoring" {
  name        = "monitoring server-sg"
  description = "rules for monitoring"
  vpc_id      = "vpc-0fc26fe53d6c17730" # Replace with your VPC ID

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    description = "Prometheus"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    description = "Grafana"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    description = "HTTPS"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 9100
    to_port     = 9100
    description = "node_exporter"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


}
resource "aws_eip" "monitoring_eip" {
  vpc = true
  instance= aws_instance.monitoring-instance.id
}

resource "aws_security_group_rule" "allow__all_outbound" {
  security_group_id = aws_security_group.monitoring.id
  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
}
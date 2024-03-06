provider "aws" {
  region = "us-east-1"
  profile = "project"
}

resource "aws_instance" "test-instance" {
  ami           = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.large"
  Name = "jenkins-instance"
    user_data = <<-EOF
              sudo apt-get update
              sudo apt-get install docker.io -y
              sudo usermod -aG docker $USER  # Replace with your system's username, e.g., 'ubuntu'
              newgrp docker
              sudo chmod 777 /var/run/docker.sock
              docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
              https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
              echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
              https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
              /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update
              sudo apt-get install jenkins
              sudo systemctl start jenkins
              sudo systemctl enable jenkins
              EOF

#  tags = {
#    Name = "example-instance"
}

# Continuous Static Code Analysis Tool - SonarQube
resource "aws_instance" "IMS_sonarqube" {
  ami                    = var.ami
  instance_type          = var.sonar_instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id_1a
  vpc_security_group_ids = ["sg-0079d5b752b2c5e99"]


  #user_data              = file("C:\Users\srava\Desktop\Terraform\Iac-Terraform\sonarqube.sh.txt")

  user_data = <<-EOF
  #!/bin/bash
  sudo hostnamectl set-hostname "sonarqube.inventorymanagementsystem.io"
  echo "`hostname -I | awk '{ print $1 }'` `hostname`" >> /etc/hosts
  sudo apt-get update
  sudo apt-get install git wget unzip zip curl tree -y
  sudo apt-get install docker.io -y
  sudo usermod -aG docker ubuntu
  sudo chmod 777 /var/run/docker.sock
  sudo systemctl enable docker
  sudo systemctl restart docker
  sudo docker pull sonarqube
  sudo docker images
  docker volume create sonarqube-conf
  docker volume create sonarqube-data
  docker volume create sonarqube-logs
  docker volume create sonarqube-extensions
  docker volume inspect sonarqube-conf
  docker volume inspect sonarqube-data
  docker volume inspect sonarqube-logs
  docker volume inspect sonarqube-extensions
  mkdir /sonarqube
  ln -s /var/lib/docker/volumes/sonarqube-conf/_data /sonarqube/conf
  ln -s /var/lib/docker/volumes/sonarqube-data/_data /sonarqube/data
  ln -s /var/lib/docker/volumes/sonarqube-logs/_data /sonarqube/logs
  ln -s /var/lib/docker/volumes/sonarqube-extensions/_data /sonarqube/extensions
  docker run -d --name Inventorymanagemetsystemsonarqube -p 9000:9000 -p 9092:9092 -v sonarqube-conf:/sonarqube/conf -v sonarqube-data:/sonarqube/data -v sonarqube-logs:/sonarqube/logs -v sonarqube-extensions:/sonarqube/extensions sonarqube


  EOF


  tags = {
    Name        = "SonarQube"
    Environment = "Dev"
    ProjectName = "Inventory Management System"
    ProjectID   = "2024"
    CreatedBy   = "IaC Terraform"
  }
}

# Outputs
output "sonar_ami" {
  value = aws_instance.IMS_jenkins.ami
}

output "sonar_public_ip" {
  value = aws_instance.IMS_sonarqube.public_ip
}
output "sonar_private_ip" {
  value = aws_instance.IMS_sonarqube.private_ip
}


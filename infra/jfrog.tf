# Continuous Binary Code Repository - JFROG
resource "aws_instance" "IMS_jfrog" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id_1a
  vpc_security_group_ids = ["sg-0079d5b752b2c5e99"]


  #user_data              = file("C:\Users\srava\Desktop\Terraform\Iac-Terraform\Jfrog.sh.txt")

  user_data = <<-EOF

  #!/bin/bash
  sudo hostnamectl set-hostname "jfrog.inventorymanagementsystem.io"
  echo "`hostname -I | awk '{ print $1}'` `hostname`" >> /etc/hosts
  sudo apt-get update
  sudo apt-get install vim curl elinks unzip wget tree git -y
  sudo apt-get install openjdk-17-jdk -y
  sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"
  echo "JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/" >> /etc/environment
  source /etc/environment

  cd /opt/
  
  #sudo wget https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/[RELEASE]/jfrog-artifactory-oss-[RELEASE]-linux.tar.gz
  
  sudo wget https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/7.71.3/jfrog-artifactory-oss-7.71.3-linux.tar.gz
  
  tar xvzf jfrog-artifactory-oss-7.71.3-linux.tar.gz
  
  mv artifactory-oss-* jfrog
  
  sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"
  
  echo "JFROG_HOME=/opt/jfrog" >> /etc/environment
  
  #cd /opt/jfrog/app/bin/
  
  #./artifactory.sh status
  
  # Configure INIT Scripts for JFrog Artifactory
  # sudo vi /etc/systemd/system/artifactory.service

  echo "[Unit]" > /etc/systemd/system/artifactory.service
  echo "Description=JFrog artifactory service" >> /etc/systemd/system/artifactory.service
  echo "After=syslog.target network.target" >> /etc/systemd/system/artifactory.service
  echo "[Service]" >> /etc/systemd/system/artifactory.service
  echo "Type=forking" >> /etc/systemd/system/artifactory.service
  echo "ExecStart=/opt/jfrog/app/bin/artifactory.sh start" >> /etc/systemd/system/artifactory.service
  echo "ExecStop=/opt/jfrog/app/bin/artifactory.sh stop" >> /etc/systemd/system/artifactory.service
  echo "User=root" >> /etc/systemd/system/artifactory.service
  echo "Group=root" >> /etc/systemd/system/artifactory.service 
  echo "Restart=always" >> /etc/systemd/system/artifactory.service
  echo "[Install]" >> /etc/systemd/system/artifactory.service
  echo "WantedBy=multi-user.target" >> /etc/systemd/system/artifactory.service

  sudo systemctl daemon-reload
  sudo systemctl enable artifactory.service
  sudo systemctl restart artifactory.service

  #Sonar admin & admin | Jfrog admin & password 

  EOF

  tags = {
    Name        = "JFrog"
    Environment = "Dev"
    ProjectName = "Inventory Management System"
    ProjectID   = "2024"
    CreatedBy   = "IaC Terraform"
  }
}

# Outputs
output "jfrog_ami" {
  value = aws_instance.IMS_jenkins.ami
}

output "jfrog_public_ip" {
  value = aws_instance.IMS_jfrog.public_ip
}
output "jfrog_private_ip" {
  value = aws_instance.IMS_jfrog.private_ip
}







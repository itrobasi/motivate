#!/bin/bash
# Jenkins on Ubuntu 18.04.
sleep 30
sudo su <<EOF
# 1 Prerequisites:
sudo apt update && sudo apt upgrade -y && sudo apt install wget nano tree unzip git-all sshpass -y && sudo apt install openjdk-8-jdk maven -y
sleep 5

# 1 - Install Jenkins
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sleep 5
sudo service jenkins start
sleep 5
sudo update-rc.d jenkins enable
sleep 5

# 1 - Install Docker
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get install ca-certificates curl gnupg lsb-release
sleep 5
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt upgrade -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sleep 5

# 1 - Install Ansible:
# Install python 2 and 3
apt-get update
apt-get install python -y
apt-get install python3 -y
sleep 5

apt update
apt install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt install ansible -y
sleep 5

# 1 - Install AWS CLI
sudo apt update && sleep 5 && sudo apt upgrade -y
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli

# 1 - Set ubuntu and other user password and SSHPASS variable. change password later, each password must be the same.
echo 'export CICDPASS=123456' >> /etc/profile.d/exportvariable.sh
useradd -m -p 123456 -s /bin/bash jenkins
echo "ubuntu:123456" | sudo chpasswd
sleep 5

# Add users to docker group.
uuser=`whoami`
sleep 5
usermod -aG docker $uuser
sleep 5
usermod -aG docker jenkins
sleep 5

# 1 - Add ubuntu and jenkins to sudoers
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ubuntu
echo "jenkins ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins
sleep 5

# 1 - Change HostName
chmod 777 /etc/hostname
echo "jenkins" > /etc/hostname
chmod 664 /etc/hostname
sleep 5

# 1 - Enable PasswordAuthentication to Yes for all and initialhandshake with other servers via ssh keys
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sleep 5

# 1 - All restarts before reboot. Give 20mins after provisioning.
service ssh restart
sleep 5
service jenkins restart

EOF

# 1 - SSH keygen for jenkins user
sudo -i -u jenkins bash <<EOF
sudo yes '' | ssh-keygen -N '' > /dev/null
EOF
sleep 5

# 1 - SSH keygen for ubuntu user
sudo yes '' | ssh-keygen -N '' > /dev/null

sleep 5
sudo -i reboot
#theEnd

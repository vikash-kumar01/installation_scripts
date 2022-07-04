#!/bin/bash

sudo apt update -y

sudo apt install default-jre -y

java -version

sudo apt update -y

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt update -y

sudo add-apt-repository universe -y

sudo apt-get install jenkins -y

sudo service jenkins start

cat /var/lib/jenkins/secrets/initialAdminPassword

#sudo service jenkins status


#34.232.26.121


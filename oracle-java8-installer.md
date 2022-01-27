#Add the following line to /etc/apt/sources.list:#

deb https://debian.opennms.org/ stable main

#Install GPG key of the repository:#

wget -O - http://debian.opennms.org/OPENNMS-GPG-KEY | sudo apt-key add -

#Update the package index:#

sudo apt-get update

#Install oracle-java8-installer deb package:#

sudo apt-get install oracle-java8-installer

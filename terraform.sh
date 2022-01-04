#!/bin/bash

sudo apt-get install unzip

wget https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_linux_amd64.zip

unzip terraform_1.0.7_linux_amd64.zip

sudo mv terraform /usr/local/bin/

terraform --version 

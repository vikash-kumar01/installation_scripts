#!/bin/bash

echo "1st install docker"

sudo apt update && apt -y install docker.io
sudo chmod 666 /var/run/docker.sock

echo "Apply updates"
sudo apt update -y 
sudo apt upgrade -y

echo " Download Minikube Binary"
wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo cp minikube-linux-amd64 /usr/local/bin/minikube
sudo chmod +x /usr/local/bin/minikube
minikube version


echo "Install Kubectl utility"
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version -o yaml


echo "Start the minikube"
minikube start --driver=docker
minikube status



# Upgrade your Ubuntu servers

```
sudo apt update
sudo apt -y full-upgrade
[ -f /var/run/reboot-required ] && sudo reboot -f    
```

#### Install kubelet, kubeadm and kubectl

add Kubernetes repository for Ubuntu 20.04 to all the servers.
```
sudo apt update
sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
```
Then install required packages.

```
sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
```

Confirm installation by checking the version of kubectl.

```
kubectl version --client && kubeadm version
```
```
Client Version: version.Info{Major:"1", Minor:"22", GitVersion:"v1.22.2", GitCommit:"8b5a19147530eaac9476b0ab82980b4088bbc1b2", GitTreeState:"clean", BuildDate:"2021-09-15T21:38:50Z", GoVersion:"go1.16.8", Compiler:"gc", Platform:"linux/amd64"}
kubeadm version: &version.Info{Major:"1", Minor:"22", GitVersion:"v1.22.2", GitCommit:"8b5a19147530eaac9476b0ab82980b4088bbc1b2", GitTreeState:"clean", BuildDate:"2021-09-15T21:37:34Z", GoVersion:"go1.16.8", Compiler:"gc", Platform:"linux/amd64"}

```
#### Disable Swap


Turn off swap.
```
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
```
Enable kernel modules and configure sysctl.

Enable kernel modules
```
sudo modprobe overlay
sudo modprobe br_netfilter
```

 Add some settings to sysctl
 ```
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
```

Reload sysctl
```
sudo sysctl --system
```
#### Install Container runtime

##### Installing Docker runtime:

 Add repo and Install packages
 ```
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io docker-ce docker-ce-cli
```

##### Create required directories
```
sudo mkdir -p /etc/systemd/system/docker.service.d
```

##### Create daemon json config file
```
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
```

##### Start and enable Services
```
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker
```

##### Ensure you load modules
```
sudo modprobe overlay
sudo modprobe br_netfilter
```

##### Set up required sysctl params
```
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
```

##### Reload sysctl
```
sudo sysctl --system
```

#### Initialize master node

Login to the server to be used as master and make sure that the br_netfilter module is loaded:

```
lsmod | grep br_netfilter
```

Enable kubelet service.

```
sudo systemctl enable kubelet
```

Initialize kubeadm 
```
kubeadm init
```

Configure kubectl using commands in the output:
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Additional nodes can be added using the command in installation output:
```
kubeadm join k8s-cluster.computingforgeeks.com:6443 --token sr4l2l.2kvot0pfalh5o4ik \
    --discovery-token-ca-cert-hash sha256:c692fb047e15883b575bd6710779dc2c5af8073f7cab460abd181fd3ddb29a18 \
    --control-plane
```
    
 ### Install network plugin on Master

In this we’ll use Calico. You can choose any other supported network plugins.
```
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```

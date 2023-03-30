echo "Step 1: Login with root user and Install Docker ( in Master & Worker Node Both)"
sudo apt-get update -y
sudo apt-get install \
ca-certificates \
curl \
gnupg -y

echo "Add Docker’s official GPG key:"
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg -y

echo "Use the following command to set up the repository:"

echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
echo "To install the latest version, run:"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

echo "Step 2: Create a file with the name containerd.conf using the command:"
# create the file with root privileges using the vim editor
sudo vim /etc/modules-load.d/containerd.conf <<EOF
i
overlay
br_netfilter
Esc
:wq
EOF

echo "Step 3: Save the file and run the following commands:"
modprobe overlay
modprobe br_netfilter

echo "Step 4: Create a file with the name kubernetes.conf in /etc/sysctl.d folder:"
# create the file with root privileges using the vim editor
sudo vim /etc/sysctl.d/kubernetes.conf <<EOF
i
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
Esc
:wq
EOF

echo "Step 5: Run the commands to verify the changes:"
sudo sysctl --system
sudo sysctl -p

echo "Step 6: Remove the config.toml file from /etc/containerd/ Folder and run reload your system daemon:"
rm -f /etc/containerd/config.toml
systemctl daemon-reload

echo "Step 7: Add Kubernetes Repository:"
apt-get update && apt-get install -y apt-transport-https ca-certificates curl -y
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Step 8: Disable Swap"
swapoff -a

Step 9: Export the environment variable:
export KUBE_VERSION=1.23.0

echo "Step 10: Install Kubernetes:"
apt-get update -y
apt-get install -y kubelet=${KUBE_VERSION}-00 kubeadm=${KUBE_VERSION}-00 kubectl=${KUBE_VERSION}-00 kubernetes-cni=0.8.7-00
apt-mark hold kubelet kubeadm kubectl
systemctl enable kubelet
systemctl start kubelet

echo "Step 11: Now it's time to initialize our Cluster!((Only on master node))"
echo "(Only on master node)"
kubeadm init --kubernetes-version=${KUBE_VERSION}
echo "(To regenrate the tokens)"
kubeadm token create --print-join-command

echo "Step 12:(Only on master node)"
cp /etc/kubernetes/admin.conf /root/
chown $(id -u):$(id -g) /root/admin.conf
export KUBECONFIG=/root/admin.conf
echo 'export KUBECONFIG=/root/admin.conf' >> /root/.bashrc

echo "Step 13: Download the daemonset yaml file of required version like following link:"
wget https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

echo "Step 14: Now apply the daemonset yaml!"
kubectl apply -f weave-daemonset-k8s.yaml


#kubeadm join 172.31.6.21:6443 --token 93wsj9.bhkcuyvbgnkc3vyp --discovery-token-ca-cert-hash sha256:431345fd720f6540d1fa0f6099f0f7fbf4f75a683e3f90819ae915c20a60e51e

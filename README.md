# Prerequisites 1 (Setup kubernetes)
To set up a running kubernetes cluster the following tasks are required:
* [Configure servers](#configure-servers)
* [Setup master node](#setup-master-node)
* [Setup worker nodes](#setup-worker-nodes)
* [Setup pod network](#setup-pod-network)


## Configure servers
We need to install packages and perform the necessary configuration on **each server**.

### Install packages
```bash
apt update
apt install -y apt-transport-https

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt update

apt install -y kubelet kubeadm kubectl containerd
apt-mark hold kubelet kubeadm kubectl containerd
```

### Configure Containerd
```bash
# load modules for Containerd
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# set kernel paramters
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# configure Containerd
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
```

### Disable swap
Turn swap of
```bash
swapoff -a
```

Prevent from turning on after reboot by commenting out swap config in `/etc/fstab`

## Setup master node
Run only on master node
```bash
sudo kubeadm init

# if error use
sudo kubeadm init --cri-socket /run/containerd/containerd.sock
```

Make config available for user
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## Setup worker nodes
Run the command for joining worker nodes on the worker servers. 
It’s a last line in the kubeadm init output and has the following format:
```bash
kubeadm join <IP>:<port> --token <TOKEN> --discovery-token-ca-cert-hash <SHA256>
```

## Setup pod network
Kubernetes needs some addons to work properly. 
One of them is Calico for networking and network policies.
```bash
kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml
```
Find other alternatives [here](https://kubernetes.io/docs/concepts/cluster-administration/addons/#networking-and-network-policy)


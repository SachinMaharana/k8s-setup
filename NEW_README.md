lsmod | grep br_netfilter
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

echo '1' > /proc/sys/net/ipv4/ip_forward
modprobe overlay
modprobe br_netfilter
swapoff -a
sysctl --system

apt-get install  containerd.io


VERSION="v1.21.0"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz


mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
systemctl restart containerd

cat /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
pull-image-on-create: true

/etc/containerd/config.toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true

systemctl restart containerd


   sudo apt-get update
apt-get install -y apt-transport-https ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet=1.18.2-00 kubeadm=1.18.2-00 kubectl=1.18.2-00
sudo apt-mark hold kubelet kubeadm kubectl


kubeadm config print init-defaults --component-configs KubeletConfiguration

# kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta2
kubernetesVersion: v1.17.9
controlPlaneEndpoint: "184.73.91.247:6443"
networking:
        podSubnet: "192.168.0.0/16"

---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
---
kind: InitConfiguration
apiVersion: kubeadm.k8s.io/v1beta2
nodeRegistration:
  criSocket: unix:///run/containerd/containerd.sock
  

kubeadm init --config cgd.yaml  

Executing the sub commands init, join and upgrade would result in kubeadm writing the KubeletConfiguration as a file under /var/lib/kubelet/config.yaml and passing it to the local node kubelet.


```
apiVersion: kubeadm.k8s.io/v1beta2
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 1.2.3.4
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  name: ip-10-240-0-10
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
---
```




cat << EOF > /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
[Service]
ExecStart=
ExecStart=/usr/bin/kubelet --address=127.0.0.1 --pod-manifest-path=/etc/kubernetes/manifests --cgroup-driver=systemd --container-runtime=remote --runtime-request-timeout=15m --container-runtime-endpoint=unix:///run/containerd/containerd.sock
Restart=always
EOF

iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X


// works
# kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta2
kubernetesVersion: v1.17.9
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
---
kind: InitConfiguration
apiVersion: kubeadm.k8s.io/v1beta2
nodeRegistration:
  criSocket: unix:///run/containerd/containerd.sock
  

kubectl taint nodes --all node-role.kubernetes.io/master-

mot7hl.dcxj0foznro0ni04
7936881419d048e149a061f5e6c77942a86b3fcaf8ffd35ccf637c713097c47e

kubeadm join --token mot7hl.dcxj0foznro0ni04 10.240.0.31:6443 --discovery-token-ca-cert-hash sha256:7936881419d048e149a061f5e6c77942a86b3fcaf8ffd35ccf637c713097c47e





kubeadm join 184.73.91.247:6443 --token 6xxeb4.tty4z3t703n3f7gk \
    --discovery-token-ca-cert-hash sha256:8e1025715b6758ea07e4d63ff10912324b8f4f9671fd766c09ec7f9f217392c1
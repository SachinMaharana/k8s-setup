# Setup HA Kubernetes Cluster ( Stacked Cluster ) : 30 mins 


## Add AWS Access and Secret Key in .envrc file.
```
export AWS_ACCESS_KEY_ID=AKIARP7BIRQM6KWZ
export AWS_SECRET_ACCESS_KEY=fmM7HcmtTDQB90eeAqy4NoFik6qliJwAJ3

direnv allow
```

```
terraform apply --auto-approve
```

Refer `ips` file with public and private ips of the created instances.

```
ssh-add -k ~/.ssh/id_rsa
ssh -A ubuntu@3.216.23.160
```

## On All Nodes( Master,ETCD, Worker )
```
sudo su -
apt-get update && apt-get install -y apt-transport-https ca-certificates curl software-properties-common


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

apt-get update && apt-get install -y docker-ce=18.06.2~ce~3-0~ubuntu



cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload && systemctl restart docker


apt-get update -y
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF | tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update -y && apt-get install -y kubelet kubeadm kubectl

apt-mark hold kubelet kubeadm kubectl
```

## ETCD External Nodes

```
cat << EOF > /etc/systemd/system/kubelet.service.d/20-etcd-service-manager.conf
[Service]
ExecStart=
#  Replace "systemd" with the cgroup driver of your container runtime. The default value in the kubelet is "cgroupfs".
ExecStart=/usr/bin/kubelet --address=127.0.0.1 --pod-manifest-path=/etc/kubernetes/manifests --cgroup-driver=systemd
Restart=always
EOF

systemctl daemon-reload && systemctl restart kubelet
systemctl status kubelet


---
As Root
-------

export HOST0=10.240.0.30
export HOST1=10.240.0.31
export HOST2=10.240.0.32

mkdir -p /tmp/${HOST0}/ /tmp/${HOST1}/ /tmp/${HOST2}/

ETCDHOSTS=(${HOST0} ${HOST1} ${HOST2})
NAMES=("ip-10-240-0-30" "ip-10-240-0-31" "ip-10-240-0-32")

for i in "${!ETCDHOSTS[@]}"; do
HOST=${ETCDHOSTS[$i]}
NAME=${NAMES[$i]}
cat << EOF > /tmp/${HOST}/kubeadmcfg.yaml
apiVersion: "kubeadm.k8s.io/v1beta2"
kind: ClusterConfiguration
etcd:
    local:
        serverCertSANs:
        - "${HOST}"
        peerCertSANs:
        - "${HOST}"
        extraArgs:
            initial-cluster: ${NAMES[0]}=https://${ETCDHOSTS[0]}:2380,${NAMES[1]}=https://${ETCDHOSTS[1]}:2380,${NAMES[2]}=https://${ETCDHOSTS[2]}:2380
            initial-cluster-state: new
            name: ${NAME}
            listen-peer-urls: https://${HOST}:2380
            listen-client-urls: https://${HOST}:2379
            advertise-client-urls: https://${HOST}:2379
            initial-advertise-peer-urls: https://${HOST}:2380
EOF
done


kubeadm init phase certs etcd-ca

This command creates these two files:

/etc/kubernetes/pki/etcd/ca.crt
/etc/kubernetes/pki/etcd/ca.key

ls /etc/kubernetes/pki/etcd/


kubeadm init phase certs etcd-server --config=/tmp/${HOST2}/kubeadmcfg.yaml
kubeadm init phase certs etcd-peer --config=/tmp/${HOST2}/kubeadmcfg.yaml
kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST2}/kubeadmcfg.yaml
kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST2}/kubeadmcfg.yaml
cp -R /etc/kubernetes/pki /tmp/${HOST2}/

find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete

kubeadm init phase certs etcd-server --config=/tmp/${HOST1}/kubeadmcfg.yaml
kubeadm init phase certs etcd-peer --config=/tmp/${HOST1}/kubeadmcfg.yaml
kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST1}/kubeadmcfg.yaml
kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST1}/kubeadmcfg.yaml
cp -R /etc/kubernetes/pki /tmp/${HOST1}/

find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete

kubeadm init phase certs etcd-server --config=/tmp/${HOST0}/kubeadmcfg.yaml
kubeadm init phase certs etcd-peer --config=/tmp/${HOST0}/kubeadmcfg.yaml
kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST0}/kubeadmcfg.yaml
kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST0}/kubeadmcfg.yaml

find /tmp/${HOST2} -name ca.key -type f -delete
find /tmp/${HOST1} -name ca.key -type f -delete


# etcd-2
USER=ubuntu
HOST=${HOST1}
scp -r /tmp/${HOST}/* ${USER}@${HOST}:
ssh ${USER}@${HOST}

sudo -Es
chown -R root:root pki
mv pki /etc/kubernetes/

# etcd-03
USER=ubuntu
HOST=${HOST2}
scp -r /tmp/${HOST}/* ${USER}@${HOST}:
ssh ${USER}@${HOST}

sudo -Es
chown -R root:root pki
mv pki /etc/kubernetes/



kubeadm init phase etcd local --config=/tmp/${HOST0}/kubeadmcfg.yaml
kubeadm init phase etcd local --config=/home/ubuntu/kubeadmcfg.yaml
kubeadm init phase etcd local --config=/home/ubuntu/kubeadmcfg.yaml

Check
------

export HOST0=10.240.0.30
export HOST1=10.240.0.31
export HOST2=10.240.0.32

kubeadm config images list --kubernetes-version v1.19.1

ETCD_TAG=3.4.13-0


docker run --rm -it \
--net host \
-v /etc/kubernetes:/etc/kubernetes k8s.gcr.io/etcd:${ETCD_TAG} etcdctl \
--cert /etc/kubernetes/pki/etcd/peer.crt \
--key /etc/kubernetes/pki/etcd/peer.key \
--cacert /etc/kubernetes/pki/etcd/ca.crt \
--endpoints https://${HOST0}:2379 endpoint health --cluster

```

## Loadbalancer

```
apt-get update -y
apt-get install haproxy -y

vim /etc/haproxy/haproxy.cfg

...

frontend kubernetes
        bind 10.240.0.40:6443
        option tcplog
        mode tcp
        default_backend kubernetes-master-nodes

backend kubernetes-master-nodes
        mode tcp
        balance roundrobin
        option tcp-check
        server ip-10-240-0-10 10.240.0.10:6443 check fall 3 rise 2
        server ip-10-240-0-11 10.240.0.11:6443 check fall 3 rise 2
        server ip-10-240-0-12 10.240.0.12:6443 check fall 3 rise 2


systemctl restart haproxy && systemctl status haproxy

nc -vn 10.240.0.40 6443
```

## Master nodes

### I'm on ETCD $HOST0
```
export CONTROL_PLANE="ubuntu@10.240.0.10"
ssh ${CONTROL_PLANE}
sudo -Es
mkdir -p /etc/kubernetes/pki/etcd/
```

### Exit ssh and copy files from $HOST0
```
scp /etc/kubernetes/pki/etcd/ca.crt "${CONTROL_PLANE}":
scp /etc/kubernetes/pki/apiserver-etcd-client.crt "${CONTROL_PLANE}":
scp /etc/kubernetes/pki/apiserver-etcd-client.key "${CONTROL_PLANE}":
```

---

```
cp ca.crt /etc/kubernetes/pki/etcd/ca.crt

cp apiserver-etcd-client.crt /etc/kubernetes/pki/apiserver-etcd-client.crt

cp apiserver-etcd-client.key /etc/kubernetes/pki/apiserver-etcd-client.key

vim kubeadm-config.yaml

apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: stable
controlPlaneEndpoint: "54.82.17.108:6443"
networking:
        podSubnet: "192.168.0.0/16"
etcd:
    external:
        endpoints:
        - https://10.240.0.30:2379
        - https://10.240.0.31:2379
        - https://10.240.0.32:2379
        caFile: /etc/kubernetes/pki/etcd/ca.crt
        certFile: /etc/kubernetes/pki/apiserver-etcd-client.crt
        keyFile: /etc/kubernetes/pki/apiserver-etcd-client.key

kubeadm init --config kubeadm-config.yaml --upload-certs

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


// get certificate key
kubeadm init phase upload-certs --upload-certs --config kubeadm-config.yaml

// for control plan join command
kubeadm token create --print-join-command --certificate-key cf7b996798e0f7972065a258c60dfbbcdbed4a1885ff847905a9bf7d9ffcb437


kubeadm join 54.82.17.108:6443 --token tdu5sw.7qltq4reytkaoi4r --discovery-token-ca-cert-hash sha256:a97ce8d321741674763713f819c16dea7ec71c2c13d423c140f1a2161f0837b6 --control-plane --certificate-key cf7b996798e0f7972065a258c60dfbbcdbed4a1885ff847905a9bf7d9ffcb437
z
```
---


```
kubectl apply -f https://docs.projectcalico.org/v3.15/manifests/calico.yaml

kubectl create deploy nginx --image=nginx:1.10
```


---


```
ETCDCTL_API=3 etcdctl --endpoints $ENDPOINT snapshot save snapshotdb

docker run --rm -it \
--net host \
-v /etc/kubernetes:/etc/kubernetes k8s.gcr.io/etcd:${ETCD_TAG} etcdctl \
--cert /etc/kubernetes/pki/etcd/peer.crt \
--key /etc/kubernetes/pki/etcd/peer.key \
--cacert /etc/kubernetes/pki/etcd/ca.crt \
--endpoints https://${HOST0}:2379 snapshot save /snapshotdb



docker run --rm -it \
--net host \
-v /etc/kubernetes:/etc/kubernetes k8s.gcr.io/etcd:${ETCD_TAG} etcdctl \
--cert /etc/kubernetes/pki/etcd/peer.crt \
--key /etc/kubernetes/pki/etcd/peer.key \
--cacert /etc/kubernetes/pki/etcd/ca.crt \
--endpoints https://${HOST0}:2379 --write-out=table snapshot status snapshots.db


docker exec -it 788569c55bea /bin/sh


ETCDCTL_API=3 etcdctl snapshot save current.db \
  --endpoints=https://10.240.0.30:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

ETCDCTL_API=3 etcdctl --write-out=table snapshot status current.db \
  --endpoints=https://10.240.0.30:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

find / -name "whats.db"

docker cp 788569c55bea:/snapshots.db snapshots.db
```
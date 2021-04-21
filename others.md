```
kubeadm join 3.83.216.119:6443 --token zgxakn.mwjqdy339yqsh500 \
 --discovery-token-ca-cert-hash sha256:efd41e862025bc51f52181086c243f9f086149cbfad12059b8f1a6acadc5c1b1

---

kubectl run -it --image=tutum/curl client --namespace critical-app --restart=Never

kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml

# sed -i "s/169.254.20.10/$localdns/g; s/cluster.local/$domain/g; s/10.96.0.10/$kubedns/g" nodelocaldns.yaml

# kubedns=`kubectl get svc kube-dns -n kube-system -o jsonpath={.spec.clusterIP}`

# kubedns=10.96.0.10

# domain=cluster.local

# localdns=169.254.20.10

sed -i "s/**PILLAR**LOCAL**DNS**/$localdns/g; s/__PILLAR__DNS__DOMAIN__/$domain/g; s/**PILLAR**DNS**SERVER**/$kubedns/g" nodelocal.yaml

dig +short @169.254.20.10 prefetch.net

dig +short @10.240.0.2 prefetch.net

https://prefetch.net/blog/2020/05/15/using-node-local-caching-on-your-kubernetes-nodes-to-reduce-coredns-traffic/

tcpdump -i any src host 169.254.20.10 and port 53

kubectl create deployment nginx2 --image=nginx

kubectl create service nodeport nginx2 --tcp=80:80

kubectl exec -it node-local-dns-fzhgc -- cat /etc/resolv.conf

curl -4 icanhazip.com

sudo nano /etc/nginx/sites-available/main.sachinmaharana.com

server {
listen 80;
listen [::]:80;

        root /var/www/main.sachinmaharana.com/html;
        index index.html index.htm index.nginx-debian.html;

        server_name main.sachinmaharana.com;

        location / {
                try_files $uri $uri/ =404;
        }

}

sudo ln -s /etc/nginx/sites-available/ec.kaladin.us /etc/nginx/sites-enabled/

-----BEGIN CERTIFICATE-----
MIIEsDCCA5igAwIBAgIUcZMqzDGdrQPZ8H/DFyWrSXH9RGAwDQYJKoZIhvcNAQEL
BQAwgYsxCzAJBgNVBAYTAlVTMRkwFwYDVQQKExBDbG91ZEZsYXJlLCBJbmMuMTQw
MgYDVQQLEytDbG91ZEZsYXJlIE9yaWdpbiBTU0wgQ2VydGlmaWNhdGUgQXV0aG9y
aXR5MRYwFAYDVQQHEw1TYW4gRnJhbmNpc2NvMRMwEQYDVQQIEwpDYWxpZm9ybmlh
MB4XDTIwMTIzMTA0MjAwMFoXDTM1MTIyODA0MjAwMFowYjEZMBcGA1UEChMQQ2xv
dWRGbGFyZSwgSW5jLjEdMBsGA1UECxMUQ2xvdWRGbGFyZSBPcmlnaW4gQ0ExJjAk
BgNVBAMTHUNsb3VkRmxhcmUgT3JpZ2luIENlcnRpZmljYXRlMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2Zhuy1wWP3Q97/6RM4ysMgSJzf3600b4yB6I
z9P8MO2oGG1isiqjyw+DRs2ywPAjDXdM9CGq4sqnfNZcuE2q2gbtHmeGlPdrTxfg
KXxD3MJncJW7uic5zy2WYeBwCO0tOdrHUVo1i0lY38dxHD6Omvek5FDX3M2N6NB2
538jqbpMl20hK4bmFSgqgYBCOclP99kRIBEFMXs3BWKwYjSEZ1eE5TabiU7Ou1V7
KgjiRUWYwco6sh8Vkll/hICbAS3ujnLgqEM3ZAeHxl5SQHLjL36VkoLnHNFOCOlF
GqWLhAJuP3nnMbFRU0ijKAyEsyRAPvwHaVETAwDhzCfAP8PCsQIDAQABo4IBMjCC
AS4wDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
ATAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBQjvzfdAe66h4JdENw8+d0D0AftNzAf
BgNVHSMEGDAWgBQk6FNXXXw0QIep65TbuuEWePwppDBABggrBgEFBQcBAQQ0MDIw
MAYIKwYBBQUHMAGGJGh0dHA6Ly9vY3NwLmNsb3VkZmxhcmUuY29tL29yaWdpbl9j
YTAzBgNVHREELDAqghQqLnNhY2hpbm1haGFyYW5hLmNvbYISc2FjaGlubWFoYXJh
bmEuY29tMDgGA1UdHwQxMC8wLaAroCmGJ2h0dHA6Ly9jcmwuY2xvdWRmbGFyZS5j
b20vb3JpZ2luX2NhLmNybDANBgkqhkiG9w0BAQsFAAOCAQEAsjT2sjy7PW+0rApl
X5EhQOX0kBD78pkKKiKRt4gyoe++WXI9Z3rOmp8yTqV5CvttIEceJci5ExqaHsNw
BxinzEpJUGP+0iq0/XgbkkAgGO/4oV6RsPDupYkqmWLna0wYj7xfEYi9U5/9wWhn
Ll26PJXktYutuwYFRjiFvdXRxio8+DAkFs+/n/3rr1GaNZZcn+ljpnhRQkSE7is/
LSX12XzlOgvP/NjczL6SvoWqEJMeQDO+rt7OmKDJPd27dD0nmQX8Ym81wMjWOO+Z
nAFoXuOb0g/xrQV2Vaop0/SmLx69u/vwXwGXq2mYcL3P2ek+ENyQKW3B0mfM/4yj
oys4vQ==
-----END CERTIFICATE-----

-----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDZmG7LXBY/dD3v
/pEzjKwyBInN/frTRvjIHojP0/ww7agYbWKyKqPLD4NGzbLA8CMNd0z0Iariyqd8
1ly4TaraBu0eZ4aU92tPF+ApfEPcwmdwlbu6JznPLZZh4HAI7S052sdRWjWLSVjf
x3EcPo6a96TkUNfczY3o0HbnfyOpukyXbSErhuYVKCqBgEI5yU/32REgEQUxezcF
YrBiNIRnV4TlNpuJTs67VXsqCOJFRZjByjqyHxWSWX+EgJsBLe6OcuCoQzdkB4fG
XlJAcuMvfpWSgucc0U4I6UUapYuEAm4/eecxsVFTSKMoDISzJEA+/AdpURMDAOHM
J8A/w8KxAgMBAAECggEAFYDTXiRlDHND1a4+Ei6SK8U4CxPQ0EVAu6IM2iD0WK97
v6I7sSi2lBAd5IbaZee1RxTllXCoTw5A2/zhH9OJEU/C6hDIA3up7qCI5gCiQjQx
/bXGXgCXXWp/ZH/GApPRtthwfxEfnnqqnj665lQmSpkzgd6dXnQv1HSZc4okb5bL
Z4nPYhFBLZot0h7QHCB9e9Kk9vU8LKbDAW4G1udpenwgEiFkv7eq/OVVNKjcoWqe
h6YjAWrRrclDRsGLt/T6B7IN2QSPiSb7aGLpqBG90i5QjxPMW2MNMt0fzjrt3NcQ
+LYRzZvF1RPcmCTyY5LwCsfyr1XpT+0wxxNOr7khQwKBgQDwyf2jshIfWXTI7laD
O1UJejgkPeGHkSEkcZE81WpCzbdyf4UyDlEPOqmzj8Prfftp9ezEX7el1d2iKbQx
4k3hxdxfd4xISEnUZj9mFKAaPUmwcwA7ZGDsm1FYZSJX1/LS/Sp9ctjdMTmVl7Nm
vFnRKkwvangMfty4gI3iP1PuZwKBgQDnV1u6vzd/ukiKkqTYbqs7553Zv4ggP0FI
WNeCGUzrS7txRd/w0XsP3AvErYlQu2vxARUSQX5CgzsEbUjdMWz3UDQZY19q/7wt
L0qodhRxyn7wuosDgPc5r7/wh3kynS6BMw0LuOTE0Iud/0fNfDP3wiJRGLwGs1E2
8QpF6xlnJwKBgCN4Pcq9UnoXvWJT6Z6PQOmSfW6pRu2nbVBnAlQJxAtvLlTJgB9t
iHdL1u/Cf8PS3RQwy93pk630IR/gMNEgWwSlFt9hRuLm8yk8np4075it6or5hdE5
6iUwg/0XeMWj4/s8m+O65UNAGxF0NVMu77QmHO7nKiP9FBqBpWTsmzqFAoGBAOFP
5uoyFEaVUtOL0XtuBd4ZTlbmQRlPIjDpPjPamlzMbKn86QetrpKauOd8MLHtaErY
yAH4wZTcJR3BpmawHbWdarCTZTpcCpVjau452t2c4BdrR7tI3wBTGLiV6UePaNyy
sPEKydyaVHC0UeVjI2YZsLyVP4OzH9VH276PJDWfAoGBANWDi91mA4cMIfq5s7Q2
PTaTvbl9vmNO6grufQjlQUmLDW9TWW9ytVICrVwdU3mAhEKXzD2tr4kAAyXHuQ4o
Ny3UMa5OnROM8sdC4JeWz/4jddCel9b7oZQEKsVr1JGx9tjfdxklHHkJ2N1815Hy
KO4P4Z/laUOkBQW08/NsaZEY
-----END PRIVATE KEY-----

    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    ssl on;
    ssl_certificate     /etc/ssl/ca.crt;
    ssl_certificate_key    /etc/ssl/ca.key;

apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
namespace: istio-test
name: istio-test-gateway
spec:
selector:
istio: ingressgateway # use Istio default gateway implementation
servers:

- port:
  number: 80
  name: http
  protocol: HTTP
  hosts:
  - "curl.sachinmaharana.com"

---

apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
namespace: istio-test
name: istio-test-virtual-service
spec:
hosts:

- "curl.sachinmaharana.com"
  gateways:
- istio-test-gateway
  http:
- match:
  - uri:
    prefix: /echo-server-istio
    route:
  - destination:
    host: echo-server
    port: 80

sudo vim /etc/nginx/sites-available/ec.sachinmaharana.com

sudo ln -s /etc/nginx/sites-available/ec.sachinmaharana.com /etc/nginx/sites-enabled/

```

map $http_upgrade $connection_upgrade {
default Upgrade;
'' close;
}

upstream istio {
server 10.240.0.20:31336; # istio ingressgateway's node port
server 10.240.0.21:31336;
}

server {
listen 443 ssl http2;
listen [::]:443 ssl http2;
ssl on;
server_name che.sachinmaharana.com;

    ssl_certificate /etc/ssl/ca.crt;
    ssl_certificate_key /etc/ssl/ca.key;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://istio;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        # This allows the ability for the execute shell window to remain open for up to 15 minutes. Without this parameter, the default is 1 minute and will automatically close.
        proxy_read_timeout 900s;
    }

}

```

server {
listen 80;
server_name che.sachinmaharana.com;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://rancher-istio-http;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        # This allows the ability for the execute shell window to remain open for up to 15 minutes. Without this parameter, the default is 1 minute and will automatically close.
        proxy_read_timeout 900s;
    }

}

map $http_upgrade $connection_upgrade {
default upgrade;
'' close;
}

server {
listen 80;
listen [::]:80;
server_name \*;
return 301 https://$host$request_uri;
}

server {
listen 443 ssl http2;
listen [::]:443 ssl http2;
ssl on;
server_name ec.sachinmaharana.com;

    ssl_certificate /etc/ssl/ca.crt;
    ssl_certificate_key /etc/ssl/ca.key;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Port $server_port;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://wikipedia.com;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_read_timeout 900s;
    }

}

server {
listen 80;
server_name che.sachinmaharana.com;

location / {
proxy_pass http://10.240.0.21:30704;
proxy_set_header Host $host;
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;

}
}

apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
namespace: istio-test
name: istio-test-gateway
spec:
selector:
istio: ingressgateway # use Istio default gateway implementation
servers:

- port:
  number: 80
  name: http
  protocol: HTTP
  hosts:
  - "che.sachinmaharana.com"

---

apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
namespace: istio-test
name: istio-test-virtual-service
spec:
hosts:

- "che.sachinmaharana.com"
  gateways:
- istio-test-gateway
  http:
- match:
  - uri:
    prefix: /
    route:
  - destination:
    host: nginx.default.svc.cluster.local
    port:
    number: 80

---

sudo apt update -y
sudo apt install nginx -y

-----BEGIN CERTIFICATE-----
MIIEoDCCA4igAwIBAgIUO+bSsWS7DMrahsRONuMJGr3eKIgwDQYJKoZIhvcNAQEL
BQAwgYsxCzAJBgNVBAYTAlVTMRkwFwYDVQQKExBDbG91ZEZsYXJlLCBJbmMuMTQw
MgYDVQQLEytDbG91ZEZsYXJlIE9yaWdpbiBTU0wgQ2VydGlmaWNhdGUgQXV0aG9y
aXR5MRYwFAYDVQQHEw1TYW4gRnJhbmNpc2NvMRMwEQYDVQQIEwpDYWxpZm9ybmlh
MB4XDTIxMDEwNTA5MzYwMFoXDTM2MDEwMjA5MzYwMFowYjEZMBcGA1UEChMQQ2xv
dWRGbGFyZSwgSW5jLjEdMBsGA1UECxMUQ2xvdWRGbGFyZSBPcmlnaW4gQ0ExJjAk
BgNVBAMTHUNsb3VkRmxhcmUgT3JpZ2luIENlcnRpZmljYXRlMIIBIjANBgkqhkiG
9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnSqs2fBJ3nG3Tx07TNBKyqwvAQcDPZKd04/Y
fU0SkuAk5WDMIYIx0FA9bB+VdXbOeVn+FRinbFpB6us7J0lI1nqX04ypt7v1hUv7
CMmfh7hauWxUMi3efx+96CPce72KAV03eNL0YDVqB62SivvHEK2Q2L7bfiuNw6W+
PIUeWQZWZJCtr6BvVuhdmfOq4XgtfHJtTf5q4n2jTlLmA7WrPP7TTjWgwH/OYcXf
pErjXG735rNjdlqqZaFEyBN0eOCWRqYjRqnBTMLi0KJ4fqIA4A8tPBVhfoJOwaQD
mfplk6FtbNcx5c06664nfs+9HTzMj8GXAW97nM+p4ZDuelB4+wIDAQABo4IBIjCC
AR4wDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
ATAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBRNzCP86lnZXfYnxM07y3Db82P8BDAf
BgNVHSMEGDAWgBQk6FNXXXw0QIep65TbuuEWePwppDBABggrBgEFBQcBAQQ0MDIw
MAYIKwYBBQUHMAGGJGh0dHA6Ly9vY3NwLmNsb3VkZmxhcmUuY29tL29yaWdpbl9j
YTAjBgNVHREEHDAaggwqLmthbGFkaW4udXOCCmthbGFkaW4udXMwOAYDVR0fBDEw
LzAtoCugKYYnaHR0cDovL2NybC5jbG91ZGZsYXJlLmNvbS9vcmlnaW5fY2EuY3Js
MA0GCSqGSIb3DQEBCwUAA4IBAQAf5thSfAnyksxzN/xM0/O0zDvCk+zPYmNX65Ht
Tvl3f9pUrXH1gfilAYAklov3VeDraZpm/D9h0ovE7I98SaLGWcLOwovcZvxFzqjp
q3LYywWut5GW2/w/IbWgZ4U5OTgpx70sK5kPf1xgWIuK5WRZDOGGWzs5dThwzMsB
2EQ9RY1+vAMXBMDnioq8ivGM3fE0+13rf744D8woLW67m6GtK7cqIDfoRbxk5aaG
5T4VorPpJaVdOhf7owQDF+vMP4EHCEF98l177NVnLkWceCIy1sSgFyoMash90w8D
8bTV0rGEdfmEwk02N7K9yyskFh2/yhWSsYd2oqc6eMsekRqK
-----END CERTIFICATE-----

-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCdKqzZ8EnecbdP
HTtM0ErKrC8BBwM9kp3Tj9h9TRKS4CTlYMwhgjHQUD1sH5V1ds55Wf4VGKdsWkHq
6zsnSUjWepfTjKm3u/WFS/sIyZ+HuFq5bFQyLd5/H73oI9x7vYoBXTd40vRgNWoH
rZKK+8cQrZDYvtt+K43Dpb48hR5ZBlZkkK2voG9W6F2Z86rheC18cm1N/mrifaNO
UuYDtas8/tNONaDAf85hxd+kSuNcbvfms2N2WqploUTIE3R44JZGpiNGqcFMwuLQ
onh+ogDgDy08FWF+gk7BpAOZ+mWToW1s1zHlzTrrrid+z70dPMyPwZcBb3ucz6nh
kO56UHj7AgMBAAECggEAAZSwdmv5b7g+uKphBMIZz6BftUmUhuR9pqzAehUGBKyb
UBzdopalyK1XFD9gG4tQIhbE0oz03FIKi2+Z5kXYnc6gSrCQnAx7Q5A9RKGo0pfd
CaHfsbnqEeblVNxYR7AAb71yjyWZTnvamPtQ1D0EY6LMbd+fDzBoTWJ+RBVeodhx
YT6RGAjzruS2RUGxhYQzr/EuBayGfveACbbNYnMra/j2zbTWMZ6qc//w9do+90Pl
MyRlTPeM+f6tsWgNmED2cg6STLmZUyriWotD7MRsW++EaF6Ug11IfcaJFVEx/V5y
4GMNTvPf4cJmaDw4wbSUoWwUQ5Pj/EP8samWMckAzQKBgQDa1SJMlIANWDBZoxY9
r8QvPVGRInTbkbpv9J++pmIKlaSM2n8uEdAvZmRfSAPzxgMzyNVHciL9I4+zd2IV
ISwQbyj6MVEJlGNHMb6tTvOcc8FLBgYMLi+Z49sW/mofhL95S5ULDFY/YOTs9D8J
0Y3yf5XhsquO4etPnIdD2NYcJQKBgQC33E1o1WdtuPMMfh3DhElgWdUa88XbE3hU
McQ8iwgxFCo48WzXzMhkYvVGpyOST44fIho7mVJKRpR3M4JgByMu00hQ9qwfhOVY
NoUB8t4sGAXqSeSgThazQb+2xwd2rYR4JYwJMC+pPzw6mYW/C/u/1jrBEF5KBQHF
xpF0BDGmnwKBgHb9tezWQtr+vSvAlnNsg8z8FsJIbiqGj04ZQlO0vVLsE9HTbZxr
azya/LEiw6NmZI9gATkcQxJKp/T6UYcTxpYZG7sP3fTLj0BDOF+csrK77rsQx3EQ
HCod0CAsrx/8WvFlu+GKD8vesBx4o15/aCQYZDOZp9fF2OItRxAJdENRAoGANaSY
DTseNxwcBYwSQQYqpmrvSzLOilGO7PmsKIHj/PXGL+D4gank2a0ppNiE/14ouBqq
DrN4F+Wp0XF822mZsULBuaWOqI+MnoUhn2Ttv22u5CF1C/RcmSZYugotukl7+dXy
moetkDK77tj19byYUes+LzAIYo49aye5LmE+3z8CgYASjPsQpEAOtclw0+qJXfnw
owo8jFC4ixOwT0B4IGNiAVNnDP99auq4ON8lzvMYcYYHnYGyw+Q4R9itn/p08Vq/
+mkZa5PCBKC39zTeCJEqokHlcbyh/z0BUEwKN+Pt40ovyAYdV1RjsdFL5ZJ8+4SE
XriZDD6qzUEK6DsjV0aG+A==
-----END PRIVATE KEY-----

sudo mkdir -p /var/www/ec.kaladin.us/html
sudo chown -R $USER:$USER /var/www/ec.kaladin.us/html

vim /var/www/ec.kaladin.us/html/index.html

sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/ec.kaladin.us

sudo vim /etc/nginx/sites-available/ec.kaladin.us

sudo ln -s /etc/nginx/sites-available/auth.sachinmaharana.com /etc/nginx/sites-enabled/

apiVersion: v1
kind: Service
metadata:
name: echo-server
namespace: default
labels:
app: echo-server
spec:
type: ClusterIP
ports: - port: 8080
targetPort: http
protocol: TCP
name: http
selector:
app: echo-server

---

apiVersion: apps/v1
kind: Deployment
metadata:
name: echo-server
namespace: default
spec:
selector:
matchLabels:
app: echo-server
replicas: 3
template:
metadata:
labels:
app: echo-server
spec:
containers: - name: echo-server
image: gcr.io/google-containers/echoserver:1.10
ports: - containerPort: 8080
name: http

---

---

apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
namespace: default
name: istio-test-gateway
spec:
selector:
istio: ingressgateway # use Istio default gateway implementation
servers:

- port:
  number: 80
  name: http
  protocol: HTTP
  hosts:
  - "\*"

---

apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
namespace: default
name: istio-test-virtual-service
spec:
hosts:

- "ec.sachinmaharana.com"
  gateways:
- istio-test-gateway
  http:
- match:
  - uri:
    prefix: /echo-server-istio
    route:
  - destination:
    host: echo-server
    port:
    number: 80

apiVersion: v1
kind: Namespace
metadata:
name: auth-system

apiVersion: v1
kind: ServiceAccount
metadata:
name: dex
namespace: auth-system

---

apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
name: dex
namespace: auth-system
rules:

- apiGroups: ["dex.coreos.com"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["apiextensions.k8s.io"]
  resources: ["customresourcedefinitions"]
  verbs: ["create"]

---

apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
name: dex
namespace: auth-system
roleRef:
apiGroup: rbac.authorization.k8s.io
kind: ClusterRole
name: dex
subjects:

- kind: ServiceAccount
  name: dex
  namespace: auth-system

apiVersion: v1
kind: ConfigMap
metadata:
name: dex
namespace: auth-system
data:
config.yaml: |
issuer: https://auth.sachinmaharana.com/
web:
http: 0.0.0.0:5556
telemetry:
http: 0.0.0.0:5558
staticClients: - id: oidc-auth-client
redirectURIs: - 'http://dashboard.sachinmaharana.com/oauth/callback'
name: 'oidc-auth-client'
secret: root
connectors: - type: ldap
id: ldap
name: LDAP
config:
host: ldap.jumpcloud.com:636
insecureNoSSL: false
insecureSkipVerify: false
bindDN: uid=peter,ou=Users,o=5d14ab2c3baeea5e4dd5b2d6,dc=jumpcloud,dc=com
bindPW: 'Qwe123@1990'
userSearch:
baseDN: ou=Users,o=5d14ab2c3baeea5e4dd5b2d6,dc=jumpcloud,dc=com
filter: "(objectClass=inetOrgPerson)"
username: sAMAccountName
idAttr: sAMAccountName
emailAttr: sAMAccountName
nameAttr: cn
oauth2:
skipApprovalScreen: true
storage:
type: kubernetes
config:
inCluster: true

baseDN: ou=Users,o=5d14ab2c3baeea5e4dd5b2d6,dc=jumpcloud,dc=com
ldapsearch -H ldaps://ldap.jumpcloud.com:636 -x -b "ou=Users,o=5d14ab2c3baeea5e4dd5b2d6,dc=jumpcloud,dc=com" -D "uid=peter,ou=Users,o=5d14ab2c3baeea5e4dd5b2d6,dc=jumpcloud,dc=com" -W "(objectClass=inetOrgPerson)"

uid=peter,ou=Users,o=5d14ab2c3baeea5e4dd5b2d6,dc=jumpcloud,dc=com

uid=peter,ou=Users,o=5d14ab2c3baeea5e4dd5b2d6,dc=jumpcloud,dc=com
bindDN: uid=peter,ou=Users,o=5d14ab2c3baeea5e4dd5b2d6,dc=jumpcloud,dc=com

-          bindPW: 'Qwe123@1990'

https://jumpcloud.com/blog/kubernetes-auth-dex-ldap


apiVersion: v1
kind: ConfigMap
metadata:
  name: dex
  namespace: auth-system
data:
  config.yaml: |
    issuer: https://auth.sachinmaharana.com/
    web:
      http: 0.0.0.0:5556
    telemetry:
      http: 0.0.0.0:5558
    staticClients:
    - id: oidc-auth-client
      redirectURIs:
      - 'http://dashboard.sachinmaharana.com/oauth/callback'
      name: 'oidc-auth-client'
      secret: root
    connectors:
    - type: ldap
      id: ldap
      name: LDAP
      config:
        host: ldap.jumpcloud.com:636
        insecureNoSSL: false
        insecureSkipVerify: false
        bindDN: uid=peter,ou=Users,o=5d14ab2c3baeea5e4dd5b2d6,dc=jumpcloud,dc=com
        bindPW: 'Qwe123@1990'
        userSearch:
          baseDN: ou=Users,o=5d14ab2c3baeea5e4dd5b2d6,dc=jumpcloud,dc=com
          filter: "(objectClass=inetOrgPerson)"
          username: sAMAccountName
          idAttr: sAMAccountName
          emailAttr: sAMAccountName
          nameAttr: cn
    oauth2:
      skipApprovalScreen: true
    storage:
      type: kubernetes
      config:
        inCluster: true



    - --oidc-issuer-url=https://ec.sachinmaharana.com/
    - --oidc-client-id=oidc-auth-client
    - --oidc-username-claim=email
    - --oidc-groups-claim=groups
    - --oidc-ca-file=/etc/ssl/ca.crt


apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: dex
  name: dex
  namespace: auth-system
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dex
  template:
    metadata:
      labels:
        app: dex
    spec:
      serviceAccountName: dex
      containers:
      - image: quay.io/coreos/dex:v2.9.0
        name: dex
        command: ["dex", "serve", "/etc/dex/cfg/config.yaml"]
        ports:
        - name: http
          containerPort: 5556
        volumeMounts:
        - name: config
          mountPath: /etc/dex/cfg
      volumes:
      - name: config
        configMap:
          name: dex
          items:
          - key: config.yaml
            path: config.yamlcat dex-gat



apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  namespace: default
  name: istio-dex-gateway
spec:
  selector:
    istio: ingressgateway # use Istio default gateway implementation
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "auth.sachinmaharana.com"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  namespace: default
  name: istio-dex-virtual-service
spec:
  hosts:
  - "auth.sachinmaharana.com"
  gateways:
  - istio-dex-gateway
  http:
  - match:
    - uri:
        prefix: /
    route:
    - destination:
        host: echo-server
        port:
          number: 8080
```

```
kubectl run www-2 --image=nginx:1.16 --restart=Never
kubectl run --generator=run-pod/v1 www-1 --image=nginx:1.16

k run nginx --image=nginx:1.19 --restart=Never --dry-run=client -oyaml > nginx.yaml
```

leanrings:
inject secrets into pod

> base64
> secret form cmd line or yaml
> volumes(name, secret > secretName), volumeMount(name, mountPath)
> env(name, valuefrom, secretkeyref, name key)
> envfrom(secreref, name)

```
k create secret generic my-secret --dry-run=client -oyaml --from-literal='username=my-app' --from-literal='password=39528$vdg7Jb' > test-app-secret.yaml


 k run secret-test-pod --dry-run -oyaml --image=nginx > secret-test-pod.yaml

 k wait --for=condition=ready pod secret-test-pod --timeout=10s

 k run multi-pod --image=nginx --dry-run=client -oyaml > multi-pod.yaml
 k create secret generic db-user --from-literal=db-username='db-admin'
```

---


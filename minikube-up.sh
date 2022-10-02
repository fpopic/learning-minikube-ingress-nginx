#!/bin/bash

set -euo pipefail

# creates ingress-nginx-controller in -n ingress-nginx
## https://medium.com/@Oskarr3/setting-up-ingress-on-minikube-6ae825e98f82#:~:text=enabled%20by%20executing-,minikube%20addons%20enable%20ingress,-Enabling%20the%20add
## https://minikube.sigs.k8s.io/docs/handbook/addons/ingress-dns/
minikube addons enable ingress

# start minikube k8s cluster (on m1 mac https://github.com/kubernetes/minikube/issues/11193#issuecomment-1105204485)
minikube start --ports=30123:30123

kubectl apply -f web/1.namespace.yaml
kubectl apply -f web/2.deployment.yaml
kubectl apply -f web/3.service.yaml
kubectl apply -f web/4.ingress-resource.yaml

# check that NodePort is assigned as expected
kubectl get -n web service web-service --output='jsonpath={.spec.ports[0].nodePort}'
curl localhost:30123

## Set up DNS

# Note: If you are running Minikube locally, use minikube ip to get the external IP.
# The IP address displayed within the ingress list will be the internal IP.
# append ingress IP or $(minikube ip) to hosts

# https://www.cyberciti.biz/faq/sudo-append-data-text-to-file-on-linux-unix-macos/
# append to /etc/hosts
192.168.49.2 my-web.com

# dns still doesn't work
curl my-web.com

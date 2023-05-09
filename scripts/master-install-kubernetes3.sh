#!/bin/bash
mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/tigera-operator.yaml
curl https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/custom-resources.yaml -O
kubectl create -f custom-resources.yaml
sudo kubectl taint nodes --all node-role.kubernetes.io/master-
sudo kubectl taint nodes --all  node-role.kubernetes.io/control-plane-

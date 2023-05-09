#!/bin/bash
TERRAFORMAPPLY=$(terraform apply -auto-approve)
echo terraform apply completed
IPv4_KubernetesMaster=$(echo $(grep -Po 'IPv4_KubernetesMaster = \K\S+' <<< "$TERRAFORMAPPLY" | tail -1)  |  tr -d '"')
IPv4_KubernetesNode=$(echo $(grep -Po 'IPv4_KubernetesNode = \K\S+' <<< "$TERRAFORMAPPLY") |  tr -d '"')
sleep 20
ssh ubuntu@$IPv4_KubernetesMaster 'sudo bash master-install-kubernetes1.sh'
ssh ubuntu@$IPv4_KubernetesNode 'sudo bash node-install-kubernetes1.sh'
ssh ubuntu@$IPv4_KubernetesNode 'sudo bash node-install-kubernetes2.sh'
INITOUTPUT=$(ssh ubuntu@$IPv4_KubernetesMaster 'sudo bash master-install-kubernetes2.sh')
ssh ubuntu@$IPv4_KubernetesMaster 'sudo bash master-install-kubernetes3.sh'
JOINVALUE=$(grep -Po 'join \K\S+' <<< "$INITOUTPUT")
TOKENVALUE=$(grep -Po 'token \K\S+' <<< "$INITOUTPUT")
DISCOVERYVALUE=$(grep -Po 'discovery-token-ca-cert-hash \K\S+' <<< "$INITOUTPUT")
ssh ubuntu@$IPv4_KubernetesNode "sudo kubeadm join ${IPv4_KubernetesMaster}:6443 --token ${TOKENVALUE}  --discovery-token-ca-cert-hash ${DISCOVERYVALUE}"
sleep 20
ssh ubuntu@$IPv4_KubernetesMaster 'sudo kubectl apply -k .'
echo IPMaster $IPv4_KubernetesMaster
echo IPNode $IPv4_KubernetesNode

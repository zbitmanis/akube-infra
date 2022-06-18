#! /bin/bash
apt update
apt -y install python3-pip git 
pip3 install ansible 
mkdir -p /var/tmp/ansible/
cd /var/tmp/ansible/
git clone https://github.com/zbitmanis/kube-node.git
cd /var/tmp/ansible/kube-node
ansible-galaxy install -r requirements.yml
[ -d "/var/tmp/ansible/kube-node/group_vars/" ] || mkdir -p /var/tmp/ansible/kube-node/group_vars/
cat <<EOF > /var/tmp/ansible/kube-node/group_vars/k8s.yaml
install_kubernetes_node_type: master
EOF
cd /var/tmp/ansible/
git clone https://github.com/zbitmanis/k8sautojoin.git
cd k8sautojoin
pip3 install -r requirements.aws.txt
./k8sautojoin.py -C aws --delete -c clustera 
cd /var/tmp/ansible/kube-node
ansible-playbook -i inventory/hosts node.yaml
cd /var/tmp/ansible/k8sautojoin
_KUBE_JOIN_COMMAND=$(kubeadm token create --print-join-command)
_MASTER=$(echo $_KUBE_JOIN_COMMAND|awk '{ print $3 }')
_TOKEN=$(echo $_KUBE_JOIN_COMMAND|awk '{ print $5 }')
_HASH=$(echo $_KUBE_JOIN_COMMAND|awk '{ print $7 }')
./k8sautojoin.py -C aws --set -c clustera -t ${_TOKEN} -m $_MASTER -a $_HASH
sleep 300
cd /var/tmp/ansible/kube-node
ansible-playbook -i inventory/hosts argocd.yaml

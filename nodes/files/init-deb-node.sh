#! /bin/bash
apt update
apt -y install python3-pip git 
mkdir -p /var/tmp/ansible/
cd /var/tmp/ansible/
git clone https://github.com/zbitmanis/kube-node.git
cd /var/tmp/ansible/kube-node
pip3 install -r requirements.txt
ansible-galaxy install -r requirements.yml
[ -d "/var/tmp/ansible/kube-node/group_vars/" ] || mkdir -p /var/tmp/ansible/kube-node/group_vars/
cat <<EOF > /var/tmp/ansible/kube-node/group_vars/k8s.yaml
install_kubernetes_node_type: node
EOF
ansible-playbook -i inventory/hosts node.yaml
sleep 120
cd /var/tmp/ansible/
git clone https://github.com/zbitmanis/k8sautojoin.git
cd k8sautojoin
pip3 install -r requirements.aws.txt
./k8sautojoin.py -C aws --join -c clustera 

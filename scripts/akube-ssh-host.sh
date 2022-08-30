#!/bin/bash

function updateSSHHost () {
sed  -i -e "/Host $1/{n;s/Hostname .*/Hostname $2/;}"  ~/.ssh/config
}

_MASTER_NODE_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=akube-master-1" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].PublicIpAddress" --output text)
echo MASTER_NODE_IP=$_MASTER_NODE_IP

#updataSSHHost akube-master _MASTER_NODE_IP

sed -i -e "/Host akube-master/{n;s/Hostname .*/Hostname ${_MASTER_NODE_IP}/;}" ~/.ssh/config

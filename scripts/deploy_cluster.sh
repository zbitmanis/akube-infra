#!/bin/bash 
cd nodes/
terraform  apply  -auto-approve
../scripts/akube-ssh-host.sh

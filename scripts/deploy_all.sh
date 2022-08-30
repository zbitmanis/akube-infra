#!/bin/bash 
cd vpc/
terraform  apply  -auto-approve
cd ..
cd nodes/
terraform  apply  -auto-approve
../scripts/akube-ssh-host.sh

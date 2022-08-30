#!/bin/bash 
cd nodes/ 
terraform  apply  -destroy -auto-approve
cd ..
cd vpc/
terraform  apply -destroy -auto-approve

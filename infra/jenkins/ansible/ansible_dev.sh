#!/bin/bash
cd /opt/ansible/
ansible-playbook --private-key=./id_rsa -e $1 -i ./hosts_dev deploy.yaml

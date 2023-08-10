#!/bin/bash
ansible-playbook --private-key=./id_rsa -i ./hosts_main $1

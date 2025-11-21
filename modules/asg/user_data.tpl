#!/bin/bash
apt update -y
apt install -y python3 python3-pip git ansible

mkdir -p /opt/iac
cd /opt/iac

git clone https://github.com/jkozienski/todolist-cloud-project.git .
cd ansible

ansible-playbook frontend.yml
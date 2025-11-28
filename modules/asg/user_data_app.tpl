#!/bin/bash
exec > /var/log/user-data-app.log 2>&1
set -xe

apt-get update -y
apt-get install -y python3 python3-pip git

python3 -m pip install --upgrade pip
python3 -m pip install ansible
ansible-galaxy collection install amazon.aws

mkdir -p /opt/iac
cd /opt/iac

git clone https://github.com/jkozienski/terraform-aws-3tier.git .

cd ansible

ansible-playbook backend.yml -i localhost, -c local

#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -xe

apt-get update -y
apt-get install -y python3 python3-pip git ansible

mkdir -p /opt/iac
cd /opt/iac

git clone https://github.com/jkozienski/terraform-aws-3tier.git .

cd ansible

ansible-playbook -i localhost, -c local frontend.yml

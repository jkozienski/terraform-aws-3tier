#!/bin/bash
exec > /var/log/user-data-app.log 2>&1
set -xe

# full PATH for cloud-init
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# values injected from Terraform
export app_env="${app_env}"
export app_region="${app_region}"

# wait for apt locks
sleep 20

apt update -y
apt install -y python3 python3-venv python3-pip git ansible-core unzip

# prepare directory
rm -rf /opt/iac
mkdir -p /opt/iac
cd /opt/iac

# clone repo fresh
git clone https://github.com/jkozienski/terraform-aws-3tier.git .

cd ansible

# install aws modules only if needed
# ansible-galaxy collection install amazon.aws

# run playbook
ansible-playbook backend.yml -i localhost, -c local \
  -e "app_env=${app_env}" \
  -e "app_region=${app_region}"

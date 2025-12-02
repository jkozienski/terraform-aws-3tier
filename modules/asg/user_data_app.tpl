#!/bin/bash
exec > /var/log/user-data-app.log 2>&1
set -xe

export app_env="${app_env}"
export app_region="${app_region}"

apt update -y
apt install -y python3 python3-venv git ansible-core

mkdir -p /opt/iac
cd /opt/iac

git clone https://github.com/jkozienski/terraform-aws-3tier.git .

cd ansible

ansible-galaxy collection install amazon.aws

ansible-playbook backend.yml -i localhost, -c local \
  -e "app_env=${app_env}" \
  -e "app_region=${app_region}"

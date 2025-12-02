#!/bin/bash
exec > /var/log/user-data-app.log 2>&1
set -xe

export APP_ENV="${app_env}"
export AWS_REGION="${aws_region}"

apt-get update -y
apt-get install -y python3 python3-venv git ansible-core

mkdir -p /opt/iac
cd /opt/iac

git clone https://github.com/jkozienski/terraform-aws-3tier.git .

cd ansible

ansible-galaxy collection install amazon.aws

ansible-playbook backend.yml -i localhost, -c local \
  -e "app_env=${APP_ENV}" \
  -e "aws_region=${AWS_REGION}"

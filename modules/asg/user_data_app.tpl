#!/bin/bash
set -xe

echo "[BACKEND] Starting user-data at $(date)" >> /var/log/user-data-app.log

export app_env="${app_env}"
export app_region="${app_region}"
export ssm_prefix="${ssm_prefix}"
export source_repo_url="${source_repo_url}"

apt update -y >> /var/log/user-data-app.log 2>&1
apt install -y python3 python3-venv python3-pip git ansible-core >> /var/log/user-data-app.log 2>&1

mkdir -p /opt/iac
git clone "${source_repo_url}" /opt/iac >> /var/log/user-data-app.log 2>&1

cd /opt/iac/ansible

ansible-playbook backend.yml -i localhost, -c local \
  -e "app_env=${app_env}" \
  -e "aws_region=${app_region}" \
  -e "ssm_prefix=${ssm_prefix}" \
  -e "source_repo_url=${source_repo_url}" >> /var/log/user-data-app.log 2>&1

echo "[BACKEND] User-data finished at $(date)" >> /var/log/user-data-app.log

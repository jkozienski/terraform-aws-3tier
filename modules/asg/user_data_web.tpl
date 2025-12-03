#!/bin/bash
exec > /var/log/user-data.log 2>&1
set -xe

export infra_repo_url="${infra_repo_url}"
export source_repo_url="${source_repo_url}"

apt-get update -y
apt-get install -y python3 python3-pip git ansible

mkdir -p /opt/iac

git clone "${source_repo_url}" /opt/iac

cd /opt/iac/ansible

ansible-playbook frontend.yml -i localhost, -c local \
  -e "source_repo_url=${source_repo_url}" \
  -e "infra_repo_url=${infra_repo_url}"

echo "[FRONTEND] User-data finished at $(date)" >> /var/log/user-data.log

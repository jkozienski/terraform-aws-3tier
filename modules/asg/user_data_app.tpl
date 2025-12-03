Content-Type: multipart/mixed; boundary="BOUNDARY"
MIME-Version: 1.0

--BOUNDARY
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash

set -xe

export app_env="${app_env}"
export app_region="${app_region}"
export ssm_prefix="${ssm_prefix}"
export source_repo_url="${source_repo_url}"

apt update -y >> /var/log/user-data-app.log 2>&1
apt install -y python3 python3-venv python3-pip git ansible-core >> /var/log/user-data-app.log 2>&1

mkdir -p /opt/iac
git clone https://github.com/jkozienski/terraform-aws-3tier.git /opt/iac >> /var/log/user-data-app.log 2>&1

cd /opt/iac/ansible

ansible-playbook backend.yml -i localhost, -c local \
  -e "app_env=${app_env}" \
  -e "aws_region=${app_region}" \
  -e "ssm_prefix=${ssm_prefix}" \
  -e "source_repo_url=${source_repo_url}" >> /var/log/user-data-app.log 2>&1

echo "[BACKEND] User-data finished at $(date)" >> /var/log/user-data-app.log

--BOUNDARY--

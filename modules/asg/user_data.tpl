#!/bin/bash
apt update -y
apt install -y apache2 python3

systemctl enable apache2
systemctl start apache2

echo "<h1>Hostname: $(hostname -I)</h1>" > /var/www/html/index.html
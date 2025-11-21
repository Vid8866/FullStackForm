#!/usr/bin/env bash

set -e

echo ">>> Updating apt"
sudo apt update -y
sudo apt upgrade -y

echo ">>> Installing essential packages"
sudo apt install -y python3 python3-pip python3-venv git curl

echo ">>> Installing PostgreSQL"
sudo apt install -y postgresql postgresql-contrib

echo ">>> Setting up PostgreSQL user and database"
sudo -u postgres psql <<EOF
CREATE USER "user" WITH PASSWORD 'pass';
CREATE DATABASE demo OWNER "user";
GRANT ALL PRIVILEGES ON DATABASE demo TO "user";
EOF

echo ">>> Installing Redis"
sudo apt install -y redis-server
sudo systemctl enable redis-server
sudo systemctl start redis-server

echo ">>> Installing Nginx"
sudo apt install -y nginx

echo ">>> Copying Nginx config"
sudo cp /app/nginx/default.conf /etc/nginx/sites-available/default
sudo systemctl restart nginx

echo ">>> Installing Python requirements"
pip3 install -r /app/app/requirements.txt

echo ">>> Copying systemd service"
sudo cp /vagrant/flaskapp.service /etc/systemd/system/flaskapp.service

echo ">>> Enabling systemd service"
sudo systemctl daemon-reload
sudo systemctl enable flaskapp
sudo systemctl start flaskapp

echo ">>> Provisioning completed successfully!"

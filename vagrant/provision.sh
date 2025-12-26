#!/usr/bin/env bash
set -e

echo "==============================="
echo " Updating system packages..."
echo "==============================="
sudo apt update -y

echo "==============================="
echo " Installing system dependencies..."
echo "==============================="
sudo apt install -y python3-pip python3-venv redis-server postgresql postgresql-contrib

echo "==============================="
echo " Setting up application..."
echo "==============================="
git clone https://github.com/Vid8866/FullStackForm.git
cd FullStackForm/application/app

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

echo "==============================="
echo " Configuring PostgreSQL..."
echo "==============================="
sudo -u postgres psql <<EOF
CREATE USER "user" WITH PASSWORD 'pass';
CREATE DATABASE demo OWNER "user";
GRANT ALL PRIVILEGES ON DATABASE demo TO "user";
EOF

echo "==============================="
echo " Setting up Redis..."
echo "==============================="
sudo systemctl enable redis-server
sudo systemctl start redis-server

echo "==============================="
echo " Creating systemd service for Flask..."
echo "==============================="

sudo cp /home/vagrant/FullStackForm/vagrant/flaskapp.service \
        /etc/systemd/system/flaskapp.service

sudo systemctl daemon-reload
sudo systemctl enable flaskapp
sudo systemctl start flaskapp

echo "==============================="
echo " ALL DONE!"
echo "==============================="

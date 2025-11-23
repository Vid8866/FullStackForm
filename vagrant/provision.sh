#!/usr/bin/env bash
set -e

APP_DIR="/home/vagrant/FullStackForm/application/app"
cd "$APP_DIR"

echo "==============================="
echo " Updating system packages..."
echo "==============================="
sudo apt update -y


echo "==============================="
echo " Installing system dependencies..."
echo "==============================="
sudo apt install -y python3-pip python3-venv

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

echo "==============================="
echo " Configuring PostgreSQL..."
echo "==============================="

sudo apt install -y postgresql postgresql-contrib
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
echo " Configuring Nginx reverse proxy..."
echo "==============================="

sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80;

    location / {
        proxy_pass http://127.0.0.1:5001;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

sudo systemctl restart nginx

python3 main.py

echo "==============================="
echo " ALL DONE!"
echo "==============================="

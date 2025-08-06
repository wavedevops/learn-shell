#!/bin/bash

# Get the script directory path
script=$(realpath "$0")
script_path=$(dirname "$script")

# Helper function to print headings
print_head() {
  echo -e "\e[33m>>>>>>> $1 <<<<<<<\e[0m"
}

# Helper function to check the last command status
code_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m✔ success\e[0m"
  else
    echo -e "\e[31m✘ failure\e[0m"
    exit 1
  fi
}

# NodeJS Setup
print_head "Disable existing NodeJS module"
dnf module disable nodejs -y
code_check

print_head "Enable NodeJS 20 module"
dnf module enable nodejs:20 -y
code_check

print_head "Install NodeJS"
dnf install nodejs -y
code_check

# Application Setup
print_head "Create roboshop user"
useradd roboshop &>/dev/null
code_check

print_head "Create /app directory"
mkdir -p /app
code_check

print_head "Download application content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip
code_check

print_head "Extract application content"
cd /app
unzip -o /tmp/catalogue.zip
code_check

print_head "Install NodeJS dependencies"
npm install
code_check

# Systemd Service
print_head "Copy catalogue service file"
cp ${script_path}/catalogue.service /etc/systemd/system/catalogue.service
code_check

print_head "Reload systemd and start catalogue service"
systemctl daemon-reload
code_check

systemctl enable catalogue
code_check

systemctl start catalogue
code_check

# MongoDB Client Setup
print_head "Copy MongoDB repo file"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
code_check

print_head "Install Mongo Shell"
dnf install mongodb-mongosh -y
code_check

print_head "Load schema into MongoDB"
mongosh --host MONGODB-SERVER-IPADDRESS </app/db/master-data.js
code_check

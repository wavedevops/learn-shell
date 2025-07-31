#!/bin/bash
#
#script=$(realpath "$0")
#script_path=$(dirname "$script")
#source ${script_path}/common.sh
#
#component=catalogue
#schema_type=mongo
#
#nodejs
#schema_setup "$schema_type" "mongo"



LOG_FILE="/tmp/catalogue_setup_$(date +%F_%H-%M-%S).log"
#exec &>>$LOG_FILE

print_head() {
  echo -e "\e[33m>>>>>>> $1 <<<<<<<\e[0m"
}

code_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSuccess\e[0m"
  else
    echo -e "\e[31mFailure\e[0m"
    exit 1
  fi
}

print_head "Disable existing NodeJS module"
dnf module disable nodejs -y
code_check

print_head "Enable NodeJS 20 module"
dnf module enable nodejs:20 -y
code_check

print_head "Add application user"
id roboshop &>/dev/null || useradd roboshop
code_check

print_head "Create application directory"
rm -rf /app
mkdir /app
code_check

print_head "Download application content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip
code_check

print_head "Extract application content"
unzip /tmp/catalogue.zip -d /app
code_check

print_head "Install NodeJS dependencies"
cd /app
npm install
code_check

print_head "Copy systemd service file"
cp catalogue.service /etc/systemd/system/catalogue.service
code_check

print_head "Start catalogue service"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue
code_check

print_head "Setup MongoDB repo"
cp mongo.repo /etc/yum.repos.d/mongo.repo
code_check

print_head "Install MongoDB shell client"
dnf install mongodb-mongosh -y
code_check

print_head "Load MongoDB schema"
mongosh --host 35.173.57.89 </app/db/master-data.js
code_check

#!/bin/bash

# Get script location
script=$(realpath "$0")
script_path=$(dirname "$script")

# variables
app_user=roboshop

print_head() {
  echo -e "\e[33m>>>>>>> $1 <<<<<<<\e[0m"
}

code_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m✔ success\e[0m"
  else
    echo -e "\e[31m✘ failure\e[0m"
    exit 1
  fi
}

schema_setup() {
  if [ "$schema_type" == "mongo" ]; then
    print_head "Copy MongoDB repo file"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
    code_check

    print_head "Install Mongo Shell"
    dnf install mongodb-mongosh -y
    code_check

    print_head "Load schema into MongoDB"
    mongosh --host MONGODB-SERVER-IPADDRESS </app/db/master-data.js
    code_check
  fi
}

download_and_extract() {
  print_head "Download $component application content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip
  code_check

  print_head "Extract $component content"
  rm -rf /app/*
  mkdir -p /app
  cd /app
  unzip -o /tmp/${component}.zip
  code_check
}

systemd_setup() {
  print_head "Copy systemd service file for $component"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  code_check

  print_head "Start $component service using systemd"
  systemctl daemon-reload
  code_check

  systemctl enable ${component}
  code_check

  systemctl restart ${component}
  code_check
}

nodejs_app_setup() {
  print_head "Disable existing NodeJS module"
  dnf module disable nodejs -y
  code_check

  print_head "Enable NodeJS 20 module"
  dnf module enable nodejs:20 -y
  code_check

  print_head "Install NodeJS"
  dnf install nodejs -y
  code_check

  print_head "Create roboshop user"
  id ${app_user} &>/dev/null || useradd ${app_user}
  code_check

  download_and_extract

  print_head "Install NodeJS dependencies"
  npm install
  code_check

  schema_setup

  systemd_setup
}

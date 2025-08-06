#!/bin/bash

# Get script location
script=$(realpath "$0")
script_path=$(dirname "$script")

# -----------------------
# 💡 Helper Functions
# -----------------------

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

# -----------------------
# 🔁 DRY: Download & Extract
# -----------------------
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
  id roboshop &>/dev/null || useradd roboshop
  code_check

  download_and_extract

  print_head "Install NodeJS dependencies"
  npm install
  code_check

  print_head "Copy systemd service file"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  code_check

  print_head "Start $component service"
  systemctl daemon-reload
  code_check

  systemctl enable ${component}
  code_check

  systemctl start ${component}
  code_check
}

## -----------------------
## 🟢 Call the Function Here
## -----------------------
#
#component=catalogue  # change this for other components like user, cart, etc.
#nodejs_app_setup

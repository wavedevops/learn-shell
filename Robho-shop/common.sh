#!/bin/bash
LOG_FILE="/tmp/expense_$(date +%F_%H-%M-%S).log"
rm -f $LOG_FILE

code_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32msuccess\e[0m"
  else
    echo -e "\e[31mfailure\e[0m"
    exit 1
  fi
}

print_head() {
  echo -e "\e[33m>>>>>>> $1 <<<<<<<\e[0m"
}


node_js() {
  print_head "Disable and enable NodeJS module"
  dnf module disable nodejs -y &>>$LOG_FILE
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  code_check

  print_head "Install NodeJS"
  dnf install nodejs -y &>>$LOG_FILE
  code_check

  print_head "Add roboshop user"
  id roboshop &>>$LOG_FILE || useradd roboshop &>>$LOG_FILE
  code_check

  print_head "Create app directory"
  mkdir -p /app &>>$LOG_FILE
  code_check

  print_head "Download ${component} content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
  code_check

  print_head "Change to app directory"
  cd /app &>>$LOG_FILE
  code_check

  print_head "Unzip ${component} content"
  unzip -o /tmp/${component}.zip &>>$LOG_FILE
  code_check

  print_head "Download dependencies"
  npm install &>>$LOG_FILE
  code_check

  print_head "Start the service"
  systemctl enable ${component} &>>$LOG_FILE
  systemctl start ${component} &>>$LOG_FILE
  code_check
}


schema_setup() {
  if [ "$schema_type" == "mongo" ]; then
    print_head "Copying MongoDB repo file"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
    code_check

    print_head "Installing MongoDB client"
    dnf install mongodb-mongosh -y &>>$LOG_FILE
    code_check

    print_head "Loading MongoDB schema"
    mongosh --host mongodb.durgasri.in </app/schema/${component}.js &>>$LOG_FILE
    code_check
  fi
}

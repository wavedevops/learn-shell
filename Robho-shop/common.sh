#!/bin/bash

app_user=roboshop
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

schema_setup() {
  if [ "$schema_type" == "mongo" ]; then
    print_head "Copy MongoDB repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
    code_check

    print_head "Install MongoDB Client"
    dnf install mongodb-mongosh -y &>>$LOG_FILE
    code_check

    print_head "Load Schema"
    mongo --host mongodb-dev.rdevopsb72.online </app/schema/${component}.js &>>$LOG_FILE
    code_check
  fi
}

app_prereq() {
  print_head "Create Application User"
  id ${app_user} &>>$LOG_FILE
  if [ $? -ne 0 ]; then
    useradd ${app_user} &>>$LOG_FILE
  fi
  code_check

  print_head "Create Application Directory"
  rm -rf /app &>>$LOG_FILE
  mkdir /app &>>$LOG_FILE
  code_check

  print_head "Download Application Content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$LOG_FILE
  code_check

  print_head "Extract Application Content"
  cd /app
  unzip /tmp/${component}.zip &>>$LOG_FILE
  code_check
}

systemd_setup() {
  print_head "Setup SystemD Service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE
  code_check

  print_head "Start ${component} Service"
  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl restart ${component} &>>$LOG_FILE
  code_check
}

nodejs() {
  print_head "Disable and Enable NodeJS Module"
  dnf module disable nodejs -y &>>$LOG_FILE
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  code_check

  print_head "Install NodeJS"
  yum install nodejs -y &>>$LOG_FILE
  code_check

  app_prereq

  print_head "Install NodeJS Dependencies"
  npm install &>>$LOG_FILE
  code_check

  schema_setup
  systemd_setup
}

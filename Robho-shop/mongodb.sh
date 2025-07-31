#!/bin/bash
source common.sh

print_head "copying mongo repo file"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
code_check

print_head "installing mongodb"
dnf install mongodb-org -y &>>$LOG_FILE
code_check

print_head "start and enable mongodb service"
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE
code_check

print_head "Update listen address"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE
code_check

print_head "restart mongodb service"
systemctl restart mongod &>>$LOG_FILE
code_check
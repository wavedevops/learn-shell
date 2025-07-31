#!/bin/bash

# Load common functions (like print_head and code_check)
source common.sh

rm -f $LOG_FILE  # Clear previous log file

print_head "Disabling existing Nginx module"
dnf module disable nginx -y &>>$LOG_FILE
code_check

print_head "Enabling Nginx 1.24 module"
dnf module enable nginx:1.24 -y &>>$LOG_FILE
code_check

print_head "Installing Nginx"
dnf install nginx -y &>>$LOG_FILE
code_check

print_head "Removing default HTML content"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
code_check

print_head "Copying custom Nginx config"
cp nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
code_check

print_head "Downloading frontend application content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
code_check

print_head "Extracting frontend content"
cd /usr/share/nginx/html &>>$LOG_FILE
unzip /tmp/frontend.zip &>>$LOG_FILE
code_check

print_head "Starting and Enabling Nginx service"
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
code_check

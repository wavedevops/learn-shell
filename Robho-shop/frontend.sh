#!/bin/bash
source common.sh

print_head
code_check

print_head module disable nginx
dnf module disable nginx -y
code_check

print_head module enable nginx
dnf module enable nginx:1.24 -y

print_head install nginx
dnf install nginx -y
code_check

print_head remove the default HTML content
rm -rf /usr/share/nginx/html/*
code_check

print_head download frontend content
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
code_check

print_head unzip frontend content
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
code_check

print_head add the config
cp nginx.conf /etc/nginx/nginx.conf
code_check

print_head Start & Enable Nginx service
systemctl enable nginx
systemctl restart nginx
code_check
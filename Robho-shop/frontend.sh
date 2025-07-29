#!/bin/bash
source common.sh

print_head install nginx
dnf install nginx -y
code_check
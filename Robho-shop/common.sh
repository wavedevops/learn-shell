#!/bin/bash


LOG_FILE="/tmp/expense_$(date +%F_%H / %M / %S).log"

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

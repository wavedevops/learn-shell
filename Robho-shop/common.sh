code_check() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32msuccess\e[0m"
  else
    echo -e "\e[31mfailure\e[0m"
    exit 1
  fi
}

print_head() {
  if [ -z "$*" ]; then    ## -z use for variable empty or not
    echo "input missing"
  fi
  printf "\e[42m>>>>>>>\e[0m \e[32m"$*"\e[0m \e[42m<<<<<<<\e[0m\n"
}
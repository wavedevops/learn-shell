print_head() {
  if [ -z "$*" ]; then    ## -z use for variable empty or not
    echo "input missing"
  fi
  printf "\e[42m>>>>>>>\e[0m \e[32m%s\e[0m \e[42m<<<<<<<\e[0m\n" "$*"
}
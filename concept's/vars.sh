#!/bin/bash
# var=data
# variable names can have only A-Z , a-z , 0-9 ," _ (under square)"
# special characters not allowed
# variable should not start with number, but start with under square
# everything is a String

# $0 - Script Name
# $1-$n - argument passed in the order
# $* - &@ - all arguments
# $# - number of arguments r
# assigning value for variable
a=10
name=DevOps
# access the variable
echo "a=$a"
echo "name=${name}"


# command substitution "()"
# variable inside command
DATE=$(date +%F)
echo today date is "$DATE"


# arithmetic substitution "(())"
atrh=$((2-5+54*10))

echo ATRH = $atrh
code_check





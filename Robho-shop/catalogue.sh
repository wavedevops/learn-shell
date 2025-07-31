#!/bin/bash
script=$(realpath "$0")
script_path=$(dirname "$script")
echo ${script_path}
source ${script_path}/common.sh
component=catalogue
node_js


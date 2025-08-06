#!/bin/bash

script=$(realpath "$0")
script_path=$(dirname "$script")

source ${script_path}/common.sh

component=catalogue
schema_type=mongo

nodejs_app_setup

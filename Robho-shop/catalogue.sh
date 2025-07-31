#!/bin/bash

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=catalogue
nodejs
schema_setup=mongo

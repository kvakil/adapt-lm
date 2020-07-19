#!/bin/bash

user_data="$(readlink -f "$1")"

output_relative=output
mkdir -p "$output_relative"
output_dir="$(readlink -f "$output_relative")" 

docker run -i \
    --mount "type=bind,source=$user_data,target=/data/user" \
    --mount "type=bind,source=$output_dir,target=/model" \
     kvakil/adapt-lm/train-original

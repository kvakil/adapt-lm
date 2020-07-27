#!/bin/bash
set -Eeuox pipefail

to_absolute_path() {
    echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

user_data="$(to_absolute_path "$1")"

output_relative=output
mkdir -p "$output_relative"
output_dir="$(to_absolute_path "$output_relative")"

docker run -i \
    --mount "type=bind,source=$user_data,target=/data/user" \
    --mount "type=bind,source=$output_dir,target=/model" \
    docker.pkg.github.com/kvakil/adapt-lm/train-original:latest

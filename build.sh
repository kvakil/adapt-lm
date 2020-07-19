#!/bin/bash
if [ $# -eq 0 ]; then
    set -- data train-original
fi
for dir in "$@"; do
    pushd "$dir"
    docker build -t "kvakil/adapt-lm/$dir" .
    popd
done

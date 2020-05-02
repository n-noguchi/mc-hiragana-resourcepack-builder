#!/bin/bash

IMAGE=docker.pkg.github.com/n-noguchi/mc-hiragana-resourcepack-builder/mc-hiragana-resourcepack-builder:1.0.0

docker build -t $IMAGE . || exit 1

docker push $IMAGE || exit 1

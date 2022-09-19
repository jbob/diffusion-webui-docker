#!/bin/sh

docker run \
  -d \
  --rm \
  -p 7860:7860 \
  --name diffusion \
diffusion

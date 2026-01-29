#!/bin/bash
set -e

echo ">>> Admin Deploy started"

cd /opt/app

docker compose  -p admin -f compose.admin.yaml pull
docker compose  -p admin -f compose.admin.yaml up -d --build 

echo ">>> AdminDeploy finished"

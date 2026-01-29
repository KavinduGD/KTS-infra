#!/bin/bash
set -e

echo ">>> Admin Deploy started"

cd /opt/app

docker compose -f compose.admin.yaml pull
docker compose -f compose.admin.yaml up -d --remove-orphans

echo ">>> AdminDeploy finished"

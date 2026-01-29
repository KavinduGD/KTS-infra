#!/bin/bash
set -e

echo ">>> User Deploy started"

cd /opt/app

docker compose -p user  -f compose.user.yaml pull
docker compose -p user  -f compose.user.yaml up -d --build 

echo ">>> User Deploy finished"

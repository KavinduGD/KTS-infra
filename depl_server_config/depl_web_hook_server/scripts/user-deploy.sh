#!/bin/bash
set -e

echo ">>> User Deploy started"

cd /opt/app

docker compose -f compose.user.yaml pull
docker compose -f compose.user.yaml up -d --remove-orphans

echo ">>> User Deploy finished"

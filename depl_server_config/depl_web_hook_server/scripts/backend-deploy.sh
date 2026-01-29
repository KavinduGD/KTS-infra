#!/bin/bash
set -e

echo ">>> Backend Deploy started"

cd /opt/app

docker compose -f compose.backend.yaml pull
docker compose -f compose.backend.yaml up -d --remove-orphans

echo ">>> Backend Deploy finished"

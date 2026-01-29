#!/bin/bash
set -e

echo ">>> Backend Deploy started"

cd /opt/app

docker compose -p backend  -f compose.backend.yaml pull
docker compose -p backend -f compose.backend.yaml up -d --build 

echo ">>> Backend Deploy finished"

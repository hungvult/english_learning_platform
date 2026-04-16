#!/bin/bash
# Wait for SQL Server to be ready, then create the database if it doesn't exist.
# This runs ONCE as an init container before seeder and backend start.

set -e

SA_PASSWORD="${SA_PASSWORD:-YourStrong!Passw0rd}"
DB_NAME="${DB_NAME:-EnglishLearning}"
SERVER="${DB_SERVER:-sqlserver}"

echo "[init-db] Waiting for SQL Server to accept connections..."
for i in $(seq 1 30); do
    if /opt/mssql-tools18/bin/sqlcmd -S "$SERVER" -U sa -P "$SA_PASSWORD" -Q "SELECT 1" -No -C > /dev/null 2>&1; then
        echo "[init-db] SQL Server is ready."
        break
    fi
    echo "[init-db] Attempt $i/30 — not ready yet, waiting 5s..."
    sleep 5
done

echo "[init-db] Creating database '$DB_NAME' if it does not exist..."
/opt/mssql-tools18/bin/sqlcmd -S "$SERVER" -U sa -P "$SA_PASSWORD" -No -C -Q \
    "IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = '$DB_NAME') CREATE DATABASE [$DB_NAME];"

echo "[init-db] Done."

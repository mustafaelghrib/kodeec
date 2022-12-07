#!/bin/sh

set -e

cd /backend/
. /opt/venv/bin/activate

echo "[entrypoint.sh] Apply migrations"
flask db init || true
flask db migrate
flask db upgrade

echo "[entrypoint.sh] Start the server"
gunicorn -b 0.0.0.0 'manage:app'

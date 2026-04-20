#!/bin/sh

set -e

cd /home/site/wwwroot
exec gunicorn --bind=0.0.0.0:${PORT:-8000} --timeout 600 \
    --worker-class uvicorn.workers.UvicornWorker API.nfl_playoffs_api:app

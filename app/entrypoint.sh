#!/usr/bin/env sh
set -e

trap "echo 'Gracefully stopping...'; kill -SIGINT $PID; wait $PID" SIGTERM
if [ $# -gt 0 ]; then
  uvicorn app.main:api $@ &
else
  uvicorn app.main:api \
		--host 0.0.0.0  \
		--port ${PORT:-3000} \
		--access-log &
fi
PID=$!
wait $PID

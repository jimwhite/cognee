#!/usr/bin/env bash
set -e

cd /workspaces/cognee

# Start the Cognee backend API in the background.
uv run python -m cognee.api.client &
BACKEND_PID=$!

# Wait for the backend to be ready.
for i in {1..60}; do
    if curl -sf http://localhost:8000/health > /dev/null 2>&1 || curl -sf http://localhost:8000/ > /dev/null 2>&1; then
        break
    fi
    sleep 1
done

# Start the Next.js frontend dev server.
cd /workspaces/cognee/cognee-frontend
npm run dev &
FRONTEND_PID=$!

# Keep the script running so devcontainer doesn't terminate the services.
wait $BACKEND_PID $FRONTEND_PID

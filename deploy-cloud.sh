#!/bin/bash
set -e

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: Docker is not installed. Please install Docker first."
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "Error: Docker Compose is not available. Please install Docker Compose or use Docker Desktop."
  exit 1
fi

if [ ! -f .env ]; then
  if [ -f .env.example ]; then
    cp .env.example .env
    echo "Created .env from .env.example. Please edit .env and set OPENAI_API_KEY before continuing if needed."
  else
    echo "Warning: .env file not found and .env.example is missing."
  fi
fi

# Build and start services
docker compose pull || true
docker compose build
docker compose up -d

echo "Deployment complete."
echo "Visit http://<server-ip>:4173 for the frontend."
echo "Backend health check: http://<server-ip>:8000/health"

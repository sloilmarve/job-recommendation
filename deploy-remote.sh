#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./deploy-remote.sh <user>@<host> <repo-url> [deploy-dir]

Example:
  ./deploy-remote.sh user@server.example.com git@github.com:yourname/project1.git ~/project1

This script clones or updates the repository on the remote server,
creates a .env file if needed, and starts Docker Compose.
EOF
}

if [ "$#" -lt 2 ]; then
  usage
  exit 1
fi

REMOTE="$1"
REPO_URL="$2"
DEPLOY_DIR="${3:-~/project1}"
SSH_CMD="ssh -o StrictHostKeyChecking=no"

echo "Deploying to $REMOTE"
echo "Remote repository: $REPO_URL"
echo "Remote path: $DEPLOY_DIR"

$SSH_CMD "$REMOTE" <<REMOTE_CMDS
set -e
if ! command -v docker >/dev/null 2>&1; then
  echo "Error: Docker is not installed on the remote host. Install Docker first."
  exit 1
fi
if ! command -v git >/dev/null 2>&1; then
  echo "Error: Git is not installed on the remote host. Install Git first."
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo "Error: Docker Compose is not installed or available on the remote host."
  exit 1
fi
REMOTE_DEPLOY_DIR="$DEPLOY_DIR"
REMOTE_DEPLOY_DIR="${REMOTE_DEPLOY_DIR/#\~/$HOME}"
mkdir -p "$REMOTE_DEPLOY_DIR"
cd "$REMOTE_DEPLOY_DIR"
if [ -d .git ]; then
  git pull --rebase
else
  rm -rf ./*
  git clone "$REPO_URL" .
fi
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
  echo "Created .env from .env.example on remote host. Edit .env to add OPENAI_API_KEY if needed."
fi
docker compose pull || true
docker compose build
docker compose up -d
REMOTE_CMDS

echo "Remote deployment complete."
echo "Open http://<server-ip>:4173 and check backend at http://<server-ip>:8000/health"

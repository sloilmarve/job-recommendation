param(
    [Parameter(Mandatory=$true)]
    [string]$Remote,

    [Parameter(Mandatory=$true)]
    [string]$RepoUrl,

    [string]$DeployDir = '~/project1'
)

if (-not (Get-Command ssh -ErrorAction SilentlyContinue)) {
    Write-Error 'SSH is not available on this machine. Install OpenSSH client first.'
    exit 1
}

$sshOptions = '-o StrictHostKeyChecking=no'
Write-Host "Deploying to $Remote"
Write-Host "Repository: $RepoUrl"
Write-Host "Remote path: $DeployDir"

$remoteCommands = @"
set -e
if ! command -v docker >/dev/null 2>&1; then
  echo 'Error: Docker is not installed on the remote host. Install Docker first.'
  exit 1
fi
if ! command -v git >/dev/null 2>&1; then
  echo 'Error: Git is not installed on the remote host. Install Git first.'
  exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
  echo 'Error: Docker Compose is not installed or available on the remote host.'
  exit 1
fi
REMOTE_DEPLOY_DIR="$DeployDir"
REMOTE_DEPLOY_DIR="${REMOTE_DEPLOY_DIR/#\~/$HOME}"
mkdir -p "$REMOTE_DEPLOY_DIR"
cd "$REMOTE_DEPLOY_DIR"
if [ -d .git ]; then
  git pull --rebase
else
  rm -rf ./*
  git clone "$RepoUrl" .
fi
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
  echo 'Created .env from .env.example on remote host. Edit .env to add OPENAI_API_KEY if needed.'
fi
docker compose pull || true
docker compose build
docker compose up -d
"@

ssh $sshOptions $Remote $remoteCommands
Write-Host 'Remote deployment complete.'
Write-Host 'Open http://<server-ip>:4173 and check backend at http://<server-ip>:8000/health'
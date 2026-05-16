param()

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Error 'Docker is not installed or not on PATH. Please install Docker Desktop or Docker Engine.'
    exit 1
}

Write-Host 'Running docker compose up --build...'

docker compose up --build

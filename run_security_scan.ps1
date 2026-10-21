
$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force -Path "reports" | Out-Null

Write-Host "`n=== 1. Scanning project files ===" -ForegroundColor Cyan

trivy fs `
    --scanners vuln,secret,misconfig `
    --severity HIGH,CRITICAL `
    --exit-code 1 `
    --format json `
    --output reports\filesystem-security.json `
    .

$filesystemExit = $LASTEXITCODE

Write-Host "`n=== 2. Scanning Docker image ===" -ForegroundColor Cyan

trivy image `
    --scanners vuln,secret `
    --severity HIGH,CRITICAL `
    --exit-code 1 `
    --format json `
    --output reports\image-security.json `
    devsecops-ia:latest

$imageExit = $LASTEXITCODE

Write-Host "`n=== Security gate summary ===" -ForegroundColor Cyan
Write-Host "Filesystem report: reports\filesystem-security.json"
Write-Host "Image report: reports\image-security.json"

if ($filesystemExit -ne 0 -or $imageExit -ne 0) {
    Write-Host "SECURITY GATE: FAILED" -ForegroundColor Red
    exit 1
}

Write-Host "SECURITY GATE: PASSED" -ForegroundColor Green
exit 0

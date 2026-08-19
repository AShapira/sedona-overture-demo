param(
    [string]$EnvFile = ".env.windows-s3-airgap",
    [string]$ComposeFile = "compose.windows-s3-airgap.yml",
    [string[]]$Notebooks = @(
        "notebooks/00_environment_and_release.ipynb",
        "notebooks/05_divisions.ipynb"
    )
)

$ErrorActionPreference = "Stop"
$composeArgs = @("compose", "--env-file", $EnvFile, "-f", $ComposeFile)

& docker @composeArgs up -d
if ($LASTEXITCODE -ne 0) {
    throw "Docker Compose failed to start the S3-only lab."
}

& docker @composeArgs exec -T lab python3 -c `
    "from pathlib import Path; Path('/scratch/executed').mkdir(parents=True, exist_ok=True)"
if ($LASTEXITCODE -ne 0) {
    throw "Could not prepare the scratch execution directory."
}

foreach ($notebook in $Notebooks) {
    $name = Split-Path $notebook -Leaf
    & docker @composeArgs exec -T lab jupyter execute $notebook `
        --output "/scratch/executed/$name" --timeout 1200
    if ($LASTEXITCODE -ne 0) {
        throw "Notebook smoke execution failed: $notebook"
    }
}

& docker @composeArgs exec -T lab python3 -c `
    "from overture_lab.config import load_settings; from overture_lab.scratch import scratch_status; print(scratch_status(load_settings()).as_dict())"
if ($LASTEXITCODE -ne 0) {
    throw "Scratch-budget verification failed."
}

#!/usr/bin/env bash
# Helper to create venv, install deps, and run the app.
# Usage: ./scripts/run.sh [--no-install]
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"
VENV_DIR="$ROOT_DIR/.venv"
REQ_FILE="$ROOT_DIR/requirements.txt"
NO_INSTALL=false
if [[ "${1:-}" == "--no-install" ]]; then
  NO_INSTALL=true
fi
if [[ ! -d "$VENV_DIR" ]]; then
  echo "Creating virtualenv in $VENV_DIR"
  python3 -m venv "$VENV_DIR"
fi
# Activate venv
source "$VENV_DIR/bin/activate"
# Install dependencies unless requested not to
if [[ "$NO_INSTALL" == false ]]; then
  echo "Installing requirements from $REQ_FILE"
  pip install --upgrade pip
  pip install -r "$REQ_FILE"
fi
# Run uvicorn
echo "Starting uvicorn at http://127.0.0.1:8000"
exec uvicorn src.app:app --reload --host 127.0.0.1 --port 8000

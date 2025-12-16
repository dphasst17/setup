#!/usr/bin/env bash
NAME=$1
set -euo pipefail
# Simple scaffold script for an project monorepo:
# - apps/frontend : Next.js (TypeScript)
# - apps/api      : NestJS
#
# Run this script from the folder where you want the "project" directory created.

ROOT_DIR="$(pwd)/${NAME:-project}"

# Basic checks
command -v node >/dev/null 2>&1 || { echo "Node.js not found. Install Node.js >= 16"; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "npm not found. Install npm"; exit 1; }
command -v npx >/dev/null 2>&1 || { echo "npx not found. Install npm (npx included)"; exit 1; }

echo "Creating project at: $ROOT_DIR"
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR"

# Initialize git
if [ ! -d .git ]; then
    git init >/dev/null 2>&1 || true
fi
#Folder for bash helper scripts like /d/bash/nextjs.sh in windows or /home/user/bash/nextjs.sh in linux
FOLDER="/d/bash" || FOLDER="/home/fast/bash"

command bash $FOLDER/nextjs.sh

# Scaffold NestJS backend
echo "Scaffolding NestJS backend (backend)..."

command bash $FOLDER/nestjs.sh


# Simple README
cat > README.md <<'MD'
Project Repository

Structure:
- Frontend : Next.js (TypeScript)
- Backend  : NestJS

Useful commands:
- npm run dev          # runs both api and web concurrently
- npm run dev:api      # run backend (NestJS) in dev mode
- npm run dev:web      # run Next.js frontend in dev mode

Notes:
- This script used npm workspaces. Ensure your npm version supports workspaces (npm >= 7).
- If scaffold CLIs prompted during creation, inspect apps/frontend and apps/api and run `npm install` there if needed.
MD

echo "Scaffold complete. cd $ROOT_DIR and run 'npm run dev' to start both apps."
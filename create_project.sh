#!/usr/bin/env bash
#!/bin/sh
NAME=$1
set -euo pipefail

ROOT_DIR="$(pwd)/${NAME:-project}"

read OS_TYPE DISTRO VERSION <<EOF
$(sh /d/bash/os.sh)
EOF
OS=$OS_TYPE
DIS=$DISTRO
VER=$VERSION
#COMMAND=$CMD

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
echo "Choose frontend framework:"
echo "1 React"
echo "2 Next.js"
echo "3 Angular"
echo "4 Vue.js"
echo "5 Exit"
read -p "Enter choice [1-4]: " frontend_choice
#Folder for bash helper scripts like /d/bash/nextjs.sh in windows or /home/user/bash/nextjs.sh in linux or /usr/local/bash/nextjs.sh in macos
[ -d /d/bash ] &&
FOLDER="/d/bash" || FOLDER="/home/fast/bash" || FOLDER="/usr/local/bash"
mkdir -p frontend
cd frontend
case $frontend_choice in
  1) command bash $FOLDER/react.sh ;;
  2) command bash $FOLDER/nextjs.sh ;;
  3) command bash $FOLDER/angular.sh ;;
  4) command bash $FOLDER/vue.sh ;;
  5) exit ;;
esac
cd ..
# Scaffold NestJS backend
command bash $FOLDER/create_be.sh $FOLDER

# Simple README
cat > README.md <<'MD'
Project Repository

Structure:
- Frontend : ${frontend_choice}
- Backend  : ${backend_choice}

Notes:
- This script used npm workspaces. Ensure your npm version supports workspaces (npm >= 7).
- If scaffold CLIs prompted during creation, inspect apps/frontend and apps/api and run `npm install` there if needed.
MD

echo "Scaffold complete. cd $ROOT_DIR and run 'npm run dev' to start both apps."
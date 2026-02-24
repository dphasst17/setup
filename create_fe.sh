#!/usr/bin/env bash
#!/bin/sh
FOLDER=$1
echo "Choose frontend framework:"
echo "1 React"
echo "2 Next.js"
echo "3 Angular"
echo "4 Vue.js"
echo "5 Exit"
read -p "Enter choice [1-4]: " frontend_choice

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
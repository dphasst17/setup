#!/usr/bin/env bash
#!/bin/sh
FOLDER=$1

echo "Choose backend framework:"
echo "1 NestJS"
echo "2 Express.js"
echo "3 Spring Boot (Java)"
echo "4 Django (Python)"
echo "5 Laravel (PHP)"
echo "6 Zend Framework (PHP)"
echo "7 Rust Actix-Web"
echo "8 Exit"
read -p "Enter choice [1-8]: " backend_choice

if [ -z "$backend_choice" ]; then
    echo "No technology specified. Usage: bash create_be.sh <technology>"
    exit 1
fi

case $backend_choice in
  1) TECH="nestjs" ;;
  2) TECH="express" ;;
  3) TECH="spring" ;;
  4) TECH="django" ;;
  5) TECH="laravel" ;;
  6) TECH="zend" ;;
  7) TECH="rust" ;;
  8) exit ;;
  *) echo "Invalid choice. Exiting."; exit 1 ;;
esac

echo "Choose architecture type for Backend:"
echo "1 Microservices"
echo "2 Monolith"
read -p "Enter choice [1-2]: " choice
if [ "$choice" = "1" ]; then
    architecture_type="microservices"
    mkdir -p backend
    cd backend
    touch .env.example
    echo "Setting up microservices architecture..."
    read -p "Enter number of services: " num_services
    if ! [[ "$num_services" =~ ^[0-9]+$ ]]; then
        echo "Error: Please enter a valid number for services."
        exit 1
    fi
    for (( i=1; i<=num_services; i++ )); do
        read -p "Enter name for service $i: " service_name
        echo "Creating service: $service_name"
        command bash ${FOLDER}/${TECH}.sh "$service_name" "$architecture_type"
        #Do something with $service_name like scaffolding a new service or do nothing
    done
    cd ..


elif [ "$choice" = "2" ]; then
    architecture_type="monolith"
    echo "Setting up monolithic architecture..."
    command bash ${FOLDER}/${TECH}.sh "backend" "$architecture_type"
else
    echo "Invalid input. Please enter 1 for microservices or 2 for monolith."
    exit 1
fi

#!/bin/bash
function create_nest() {
    echo "Scaffolding NestJS service: $1"
    mkdir -p $1
    cd $1
    #Check nest cli
    command -v nest >/dev/null 2>&1 || { echo "NestJS CLI not found. Installing @nestjs/cli globally."; npm install -g @nestjs/cli; }
    nest new . --package-manager npm --skip-install --strict || {
        echo "Warning: @nestjs/cli scaffold had an issue. Check $1"
    }

    npm install @nestjs/common class-validator class-transformer reflect-metadata rxjs dotenv

    if [ "$2" = "microservices" ]; then
        npm i @nestjs/microservices nats
        touch Dockerfile .dockerignore

        mkdir src/nats src/@types
        touch src/nats/nats.client.module.ts
    fi
    mkdir src/config src/modules src/shared src/dto src/interfaces src/constants src/domain src/libs
    touch src/config/db.config.ts src/config/app.config.ts src/constants/index.ts src/domain/index.ts src/libs/index.ts
    rm src/app.controller.ts src/app.controller.spec.ts src/app.service.ts
    
    npm install
#Replace app.module.ts with a basic one
cat > src/app.module.ts <<'EOF'
import { Module } from '@nestjs/common';
@Module({
  imports: [],
  controllers: [],
  providers: [],
})
export class AppModule {}
EOF

    echo "NestJS service $1 scaffolded."
    cd ..
}

read -p "Enter architecture type (microservices/monolith): " architecture_type

if [ "$architecture_type" = "microservices" ] || [ "$architecture_type" = "micro" ]; then
    mkdir -p backend
    cd backend
    echo "Setting up microservices architecture..."
    read -p "Enter number of services: " num_services
    for (( i=1; i<=num_services; i++ )); do
        read -p "Enter name for service $i: " service_name
        echo "Creating service: $service_name"
        create_nest "$service_name" "microservice"
        #Doing something with $service_name like scaffolding a new service
    done
    cd ..
elif [ "$architecture_type" = "monolith" ] || [ "$architecture_type" = "mono" ]; then
    echo "Setting up monolith architecture..."
    create_nest "backend"
    # Add commands to set up monolith architecture here
else
    echo "Invalid architecture type. Please enter 'microservices' or 'monolith'. Exiting."
    exit 1
fi


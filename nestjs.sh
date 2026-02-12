#!/bin/bash
NAME=$1
ARCH_TYPE=$2
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
        # Rewrite main.ts for microservices not included api service
        # Write below here
    fi
    mkdir src/config src/modules src/shared src/dto src/interfaces src/constants src/domain src/libs
    touch src/config/db.config.ts src/config/app.config.ts src/constants/index.ts src/domain/index.ts src/libs/index.ts
    rm src/app.controller.ts src/app.controller.spec.ts src/app.service.ts
    
    npm install

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



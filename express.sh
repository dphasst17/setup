#!/bin/bash
NAME=${1:-"express-service"}
ARCH_TYPE=${2:-"monolith"}
echo "Scaffolding Express service: $NAME"
    mkdir $NAME
    cd $NAME

    npm init -y

    npm install express dotenv

    
    npm install -D typescript ts-node ts-loader @types/node @types/express \
        prettier eslint eslint-config-prettier eslint-plugin-prettier eslint-plugin-node eslint-plugin-import eslint-plugin-unused-imports \
        nodemon @types/node
    mkdir src
    touch src/index.ts src/app.ts
    mkdir src/config src/routes src/controllers src/middleware src/models src/utils
    touch src/config/db.config.ts src/config/app.config.ts
cat << 'EOF' > .eslintrc.json
{
  "env": {
    "es2021": true,
    "node": true
  },
  "extends": [
    "eslint:recommended",
    "plugin:import/recommended",
    "plugin:node/recommended",
    "plugin:prettier/recommended"
  ],
  "parserOptions": {
    "ecmaVersion": 12,
    "sourceType": "module"
  },
  "plugins": ["import", "unused-imports"],
  "rules": {
    "unused-imports/no-unused-imports": "error",
    "no-unused-vars": "off",
    "unused-imports/no-unused-vars": [
      "warn",
      { "vars": "all", "varsIgnorePattern": "^_", "args": "after-used", "argsIgnorePattern": "^_" }
    ]
  }
}
EOF
    echo "Created .eslintrc.json"
cat > tsconfig.json << 'EOF'
{
    "compilerOptions": {
      "target": "ES2022",
      "module": "ES2022",
      "moduleResolution": "node",
      "outDir": "./build",
      "rootDir": "./src",
      "strict": true,
      "esModuleInterop": true,
      "skipLibCheck": true,
      "forceConsistentCasingInFileNames": true,
      "allowImportingTsExtensions": true,
      "noEmit": true,
      "baseUrl": "./src",
      "paths": {
        "@/*": ["*"]
      },
    },
    "include": ["src/**/*"],
    "exclude": ["node_modules"],
}
EOF
    echo "Created tsconfig.json"
cat > src/index.ts <<'EOF'
import app from './app.ts';
import { APP_CONFIG } from './config/app.config.ts';
const PORT = APP_CONFIG.port;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
EOF
cat > src/app.ts <<'EOF'
import express from 'express';
import dotenv from 'dotenv';
dotenv.config();
const app = express();
app.use(express.json());
app.get('/', (req, res) => {
  res.send('Hello World!');
});
export default app;
EOF

cat > src/config/app.config.ts <<'EOF'
import dotenv from 'dotenv';
dotenv.config();
export const APP_CONFIG = {
  port: process.env.PORT || 1836,
  env: process.env.NODE_ENV || 'development',
};
EOF
cat > src/config/db.config.ts <<'EOF'
export const DB_CONFIG = {
  // Add your database configuration here
  'host': 'localhost',
  'port': 5432,
  'username': 'user',
  'password': 'password',
  'database': 'mydb',
  'dialect': 'postgres',
  'logging': false,
  'pool': {
    'max': 5,
    'min': 0,
    'acquire': 30000,
    'idle': 10000
  } 
};
EOF
    echo "Created initial source files"

cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "all",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2
}
EOF
    echo "Created .prettierrc"

cat > .gitignore << 'EOF'
node_modules
dist
.env
EOF
    echo "Created .gitignore"

cat > .env << 'EOF'
PORT=1836
NODE_ENV=development
EOF
    echo "Created .env file"


npm pkg set type="module"
npm pkg set scripts.start="nodemon --exec ts-node src/index.ts"
npm pkg set scripts.prep="prettier --write ."
echo "Express service $NAME scaffolded successfully."

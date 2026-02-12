
# Install React and dependencies
npm init -y 
# Core
npm install react react-dom @tanstack/react-router @tanstack/react-query @tanstack/react-router-devtools

# Dev Dependencies
# Webpack & loaders
npm install --save-dev webpack webpack-cli webpack-dev-server \
    babel-loader @babel/core @babel/preset-env @babel/preset-react \
    html-webpack-plugin css-loader style-loader tailwindcss @tailwindcss/postcss postcss postcss-loader autoprefixer \
    @tanstack/router-plugin \
    typescript ts-loader fork-ts-checker-webpack-plugin swc-loader \

npm install --save-dev @types/react @types/react-dom @types/node

#Set type from commonjs to module in package.json
npm pkg set type="module"
npm pkg set main="main.tsx"

# Prompt user for optional features
read -p "Did you want to install TypeScript? (y/n): " install_ts
read -p "Did you want to use Tailwind CSS? (y/n): " install_tailwind
read -p "Did you want to use Prettier for code formatting? (y/n): " install_prettier
read -p "Did you want to use React Testing Library for testing? (y/n): " install_testing
read -p "Did you want to use Axios for HTTP requests? (y/n): " install_axios
echo "Did you want to use state management?" 
echo "1) Redux Toolkit"
echo "2) Zustand"
echo "n) None"
read -p "Choose an option (1/2/n for none): " state_mgmt_choice

if [[ "$install_ts" == "y" || "$install_ts" == "Y" ]]; then
    type=ts
    typex=tsx
    npm install --save-dev typescript

    cat << 'EOF' > tsconfig.json
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "jsx": "react-jsx",
    "strict": true,
    "baseUrl": ".",
    "paths":{
      "@/*": ["src/*"]
    },
    "moduleResolution": "bundler",
    "isolatedModules": true,
    "skipLibCheck": true,

    "types": ["react", "react-dom"]
  },
  "include": ["src"]
}
EOF

    echo "Created tsconfig.json"

    cat << 'EOF' > tsconfig.webpack.json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "CommonJS",
    "types": ["node"],
    "skipLibCheck": true
  },
  "include": ["webpack.config.js"]
}
EOF

    echo "Created tsconfig.webpack.json"

    cat << EOF > tsr.config.json
    {
  "routesDirectory": "./src/routes",
  "generatedRouteTree": "./src/routeTree.gen.ts"
}
EOF

    echo "Created tsr.config.json"
else
    type=js
    typex=jsx
fi


if [[ "$install_tailwind" == "y" || "$install_tailwind" == "Y" ]]; then
    npm install -D tailwindcss @tailwindcss/postcss postcss
    echo "Configured Tailwind CSS"
    echo "export default {
  plugins: {
    \"@tailwindcss/postcss\": {},
  },
};
" > postcss.config.mjs
    echo "Created postcss.config.mjs"
    echo "export default{
  content: ['./src/**/*.{html,js,jsx,ts,tsx}'],
  theme: {
    extend: {},
  },
  plugins: [],
};" > tailwind.config.js
    echo "Created tailwind.config.js"

fi


if [[ "$install_prettier" == "y" || "$install_prettier" == "Y" ]]; then
    npm install --save-dev prettier eslint-config-prettier eslint-plugin-prettier
    npm pkg set scripts.format="prettier --write ."
fi
if [[ "$install_testing" == "y" || "$install_testing" == "Y" ]]; then
    npm install --save-dev @testing-library/react @testing-library/jest-dom jest
    files_test="tests/App.test.$type"
    #Jest config file
    echo '{
  "testEnvironment": "jsdom",
  "moduleFileExtensions": ["js", "jsx", "ts", "tsx"],
  "transform": {
    "^.+\\.(ts|tsx)$": "ts-jest",
    "^.+\\.(js|jsx)$": "babel-jest"
  },
  "moduleNameMapper": {
    "^@/(.*)$": "<rootDir>/src/$1"
  },
  "setupFilesAfterEnv": ["@testing-library/jest-dom/extend-expect"]
}' > jest.config.json
    echo "Created jest.config.json"
fi
if [[ "$install_axios" == "y" || "$install_axios" == "Y" ]]; then
    npm install axios
    files_axios="services/api.$type"
fi
case "$state_mgmt_choice" in
    1)
        npm install @reduxjs/toolkit react-redux
        files_store="store/slice.$type store/store.$type store/actions.$type store/reducer.$type store/store.$type"
        ;;
    2)
        npm install zustand
        files_store="store/store.$type"
        ;;
    n|N|none|NONE)
        ;;
    *)
        echo "Invalid choice for state management. Skipping installation."
        ;;
esac
touch .env.example webpack.config.js .babelrc

echo "Created webpack.config.js and .env.example"
#Babel config file
echo '{
  "presets": ["@babel/preset-env", "@babel/preset-react"]
}' > .babelrc
echo "Created .babelrc"

#Webpack config file
echo "import path from 'path'
import { fileURLToPath } from 'url'
import HtmlWebpackPlugin from 'html-webpack-plugin'
import { TanStackRouterWebpack } from '@tanstack/router-plugin/webpack'

const __dirname = fileURLToPath(new URL('.', import.meta.url))

/** @type import('webpack').Configuration */
export default ({ WEBPACK_SERVE }) => ({
  target: 'web',
  mode: WEBPACK_SERVE ? 'development' : 'production',
  entry: path.resolve(__dirname, './src/main.tsx'),
  output: {
    path: path.resolve(__dirname, './dist'),
    filename: '[name].bundle.js',
    publicPath: '/',
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js', '.jsx'],
    alias: {
      '@/*': path.resolve(__dirname, 'src/*'),
    }
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: path.resolve(__dirname, './public/index.html'),
      filename: 'index.html',
    }),
    TanStackRouterWebpack(),
  ],
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        exclude: /(node_modules)/,
        use: { loader: 'swc-loader' },
      },
      {
        test: /\.css$/i,
        use: [
          'style-loader',
          'css-loader',
          'postcss-loader'
        ],
      },
    ],
  },
  devServer: {
    //open the browser after server had been started
    open: false,
    hot: true,
    historyApiFallback: {
      rewrites: [{ from: /./, to: '/index.html' }],
    },
    static: ['public'],
  },
})

" > webpack.config.js
echo "Created webpack.config.js"

#Update package.json scripts
npm pkg set scripts.dev="webpack serve --mode development --port 3000"
npm pkg set scripts.build="webpack --mode production"
npm pkg set scripts.test="jest"
cat << EOF > .swcrc
{
  "jsc": {
    "parser": {
      "syntax": "typescript",
      "tsx": true
    },
    "transform": {
      "react": {
        "runtime": "automatic"
      }
    }
  }
}
EOF
echo "Created .swcrc"
cat << EOF > .gitignore
node_modules
dist
.env
.env.local
.env.example
.env.development.local
.env.test.local
.env.production.local
coverage
.DS_Store
.history
.vscode
.idea
EOF
#Create sample index file
mkdir public
cat << EOF > public/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>React App</title>
</head>
<body>
    <div id="root"></div>
</body>
</html>
EOF
###

mkdir src
cd src
mkdir components services store styles tests lib helpers hooks constants routes
if [ -n "$files_store" ]; then
  touch ${files_store}
fi
if [[ "$install_tailwind" == "y" || "$install_tailwind" == "Y" ]]; then
    echo "@import \"tailwindcss\";" > styles/tailwind.css
fi
if [ -n "$files_axios" ]; then
  touch ${files_axios}
fi
if [ -n "$files_test" ]; then
  touch ${files_test}
fi

echo "Created src directory structure"


#Config Router using TanStack Router
cat << EOF > routes/__root.$typex
import { Outlet, createRootRouteWithContext } from '@tanstack/react-router'
import { TanStackRouterDevtools } from '@tanstack/react-router-devtools'
//import Header from '../components/Header'

import type { QueryClient } from '@tanstack/react-query'

interface MyRouterContext {
  queryClient: QueryClient
}

export const Route = createRootRouteWithContext<MyRouterContext>()({
  component: () => (
    <>
      {/*<Header />*/}
      <Outlet />
      <TanStackRouterDevtools position="bottom-right" />
    </>
  ),
})

EOF
echo "Created __root.$typex"

cat << EOF > routes/index.$typex
import { createFileRoute } from '@tanstack/react-router';

export const Route = createFileRoute('/')({
  component: () => <Home />,
});
const Home = () => {
  return <div className="my-4 w-full flex justify-center text-3xl font-bold text-blue-500">Project React + Webpack</div>;
}

EOF
echo "Created index.$typex"

cat << EOF > App.$typex
import { createRouter, RouterProvider } from '@tanstack/react-router'

import { routeTree } from './routeTree.gen'

// Set up a Router instance
const router = createRouter({
  routeTree,
  defaultPreload: 'intent',
})

// Register things for typesafety
declare module '@tanstack/react-router' {
  interface Register {
    router: typeof router
  }
}
const App = () => {
  return <RouterProvider router={router} />
}

export default App
EOF
echo "Created App.$typex"
cat << EOF > main.$typex
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './styles/tailwind.css'
const rootEl = document.getElementById('root')

if (rootEl) {
  const root = ReactDOM.createRoot(rootEl)
  root.render(
    <React.StrictMode>
      <App />
    </React.StrictMode>,
  )
}
EOF
echo "Created main.$typex"

cd ..

echo "React project setup complete!"
#!/bin/bash

# Setup React Project with ESLint and Prettier configurations
# Run this script in your project directory to set up React with proper linting

# Print colorful messages
print_green() {
  echo -e "\033[0;32m$1\033[0m"
}

print_yellow() {
  echo -e "\033[0;33m$1\033[0m"
}

print_blue() {
  echo -e "\033[0;34m$1\033[0m"
}

print_red() {
  echo -e "\033[0;31m$1\033[0m"
}

# Check if npm is installed
if ! command -v npm &> /dev/null; then
  print_red "Error: npm is not installed. Please install Node.js and npm first."
  exit 1
fi

# Initialize npm if package.json doesn't exist
if [ ! -f package.json ]; then
  print_blue "Initializing npm project..."
  npm init -y
fi

# Install React dependencies
print_blue "Installing React dependencies..."
npm install react react-dom

# Install development dependencies
print_blue "Installing development dependencies..."
npm install --save-dev \
  eslint \
  prettier \
  eslint-plugin-react \
  eslint-plugin-react-hooks \
  eslint-config-prettier \
  eslint-plugin-prettier \
  @typescript-eslint/eslint-plugin \
  @typescript-eslint/parser \
  typescript \
  @types/react \
  @types/react-dom

# Create ESLint configuration
print_blue "Creating ESLint configuration..."
cat > .eslintrc.json << EOL
{
  "env": {
    "browser": true,
    "es2021": true,
    "node": true
  },
  "extends": [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "plugin:@typescript-eslint/recommended",
    "prettier"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaFeatures": {
      "jsx": true
    },
    "ecmaVersion": "latest",
    "sourceType": "module"
  },
  "plugins": [
    "react",
    "react-hooks",
    "@typescript-eslint",
    "prettier"
  ],
  "rules": {
    "prettier/prettier": "error",
    "react/react-in-jsx-scope": "off",
    "react/prop-types": "off",
    "indent": [
      "error",
      2
    ],
    "linebreak-style": [
      "error",
      "unix"
    ],
    "quotes": [
      "error",
      "double"
    ],
    "semi": [
      "error",
      "always"
    ]
  },
  "settings": {
    "react": {
      "version": "detect"
    }
  }
}
EOL

# Create Prettier configuration
print_blue "Creating Prettier configuration..."
cat > .prettierrc.json << EOL
{
  "semi": true,
  "tabWidth": 2,
  "printWidth": 100,
  "singleQuote": false,
  "trailingComma": "es5",
  "jsxBracketSameLine": false,
  "arrowParens": "avoid"
}
EOL

# Create TypeScript configuration
print_blue "Creating TypeScript configuration..."
cat > tsconfig.json << EOL
{
  "compilerOptions": {
    "target": "es5",
    "lib": [
      "dom",
      "dom.iterable",
      "esnext"
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noFallthroughCasesInSwitch": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx"
  },
  "include": [
    "src"
  ]
}
EOL

# Create .gitignore
print_blue "Creating .gitignore..."
cat > .gitignore << EOL
# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# production
/build
/dist

# misc
.DS_Store
.env.local
.env.development.local
.env.test.local
.env.production.local

npm-debug.log*
yarn-debug.log*
yarn-error.log*
EOL

# Create basic project structure
print_blue "Creating basic project structure..."
mkdir -p src
mkdir -p public

# Create a basic React component
print_blue "Creating a basic React component..."
cat > src/App.tsx << EOL
import React, { useState } from "react";

interface AppProps {
  title?: string;
}

const App: React.FC<AppProps> = ({ title = "React App" }) => {
  const [count, setCount] = useState(0);

  return (
    <div className="app">
      <h1>{title}</h1>
      <div>
        <p>You clicked {count} times</p>
        <button onClick={() => setCount(count + 1)}>
          Click me
        </button>
      </div>
    </div>
  );
};

export default App;
EOL

# Create index file
cat > src/index.tsx << EOL
import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";

const container = document.getElementById("root");
const root = createRoot(container!);
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOL

# Create HTML file
cat > public/index.html << EOL
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>React App</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
EOL

# Add scripts to package.json
print_blue "Updating package.json scripts..."
node -e "
  const fs = require('fs');
  const pkg = require('./package.json');
  
  pkg.scripts = Object.assign(pkg.scripts || {}, {
    start: 'react-scripts start',
    build: 'react-scripts build',
    test: 'react-scripts test',
    eject: 'react-scripts eject',
    lint: 'eslint \"src/**/*.{js,jsx,ts,tsx}\"',
    format: 'prettier --write \"src/**/*.{js,jsx,ts,tsx,css,scss,json}\"'
  });
  
  fs.writeFileSync('./package.json', JSON.stringify(pkg, null, 2) + '\n');
"

# Install react-scripts for running the app
npm install --save-dev react-scripts

print_green "✅ React project setup complete!"
print_yellow "To run the project:"
print_yellow "  npm start"
print_yellow "To lint the project:"
print_yellow "  npm run lint"
print_yellow "To format the project code:"
print_yellow "  npm run format"
print_blue "Your AstroVim React integration should now work properly with this project." 
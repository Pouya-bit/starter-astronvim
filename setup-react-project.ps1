# Setup React Project with ESLint and Prettier configurations
# Run this script in your project directory to set up React with proper linting

# Print colorful messages
function Write-Green {
    param([string]$text)
    Write-Host $text -ForegroundColor Green
}

function Write-Yellow {
    param([string]$text)
    Write-Host $text -ForegroundColor Yellow
}

function Write-Blue {
    param([string]$text)
    Write-Host $text -ForegroundColor Blue
}

function Write-Red {
    param([string]$text)
    Write-Host $text -ForegroundColor Red
}

# Check if npm is installed
try {
    npm --version | Out-Null
} catch {
    Write-Red "Error: npm is not installed. Please install Node.js and npm first."
    exit 1
}

# Initialize npm if package.json doesn't exist
if (-not (Test-Path "package.json")) {
    Write-Blue "Initializing npm project..."
    npm init -y
}

# Install React dependencies
Write-Blue "Installing React dependencies..."
npm install react react-dom

# Install development dependencies
Write-Blue "Installing development dependencies..."
npm install --save-dev `
    eslint `
    prettier `
    eslint-plugin-react `
    eslint-plugin-react-hooks `
    eslint-config-prettier `
    eslint-plugin-prettier `
    @typescript-eslint/eslint-plugin `
    @typescript-eslint/parser `
    typescript `
    @types/react `
    @types/react-dom

# Create ESLint configuration
Write-Blue "Creating ESLint configuration..."
@'
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
      "windows"
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
'@ | Out-File -FilePath ".eslintrc.json" -Encoding utf8

# Create Prettier configuration
Write-Blue "Creating Prettier configuration..."
@'
{
  "semi": true,
  "tabWidth": 2,
  "printWidth": 100,
  "singleQuote": false,
  "trailingComma": "es5",
  "jsxBracketSameLine": false,
  "arrowParens": "avoid",
  "endOfLine": "crlf"
}
'@ | Out-File -FilePath ".prettierrc.json" -Encoding utf8

# Create TypeScript configuration
Write-Blue "Creating TypeScript configuration..."
@'
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
'@ | Out-File -FilePath "tsconfig.json" -Encoding utf8

# Create .gitignore
Write-Blue "Creating .gitignore..."
@'
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
'@ | Out-File -FilePath ".gitignore" -Encoding utf8

# Create basic project structure
Write-Blue "Creating basic project structure..."
New-Item -ItemType Directory -Force -Path "src" | Out-Null
New-Item -ItemType Directory -Force -Path "public" | Out-Null

# Create a basic React component
Write-Blue "Creating a basic React component..."
@'
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
'@ | Out-File -FilePath "src\App.tsx" -Encoding utf8

# Create index file
@'
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
'@ | Out-File -FilePath "src\index.tsx" -Encoding utf8

# Create HTML file
@'
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
'@ | Out-File -FilePath "public\index.html" -Encoding utf8

# Update package.json scripts
Write-Blue "Updating package.json scripts..."
$packageJson = Get-Content -Raw -Path "package.json" | ConvertFrom-Json
if (-not $packageJson.scripts) {
    $packageJson | Add-Member -Type NoteProperty -Name "scripts" -Value @{}
}

$packageJson.scripts | Add-Member -Type NoteProperty -Name "start" -Value "react-scripts start" -Force
$packageJson.scripts | Add-Member -Type NoteProperty -Name "build" -Value "react-scripts build" -Force
$packageJson.scripts | Add-Member -Type NoteProperty -Name "test" -Value "react-scripts test" -Force
$packageJson.scripts | Add-Member -Type NoteProperty -Name "eject" -Value "react-scripts eject" -Force
$packageJson.scripts | Add-Member -Type NoteProperty -Name "lint" -Value "eslint ""src/**/*.{js,jsx,ts,tsx}""" -Force
$packageJson.scripts | Add-Member -Type NoteProperty -Name "format" -Value "prettier --write ""src/**/*.{js,jsx,ts,tsx,css,scss,json}""" -Force

$packageJson | ConvertTo-Json -Depth 10 | Out-File -FilePath "package.json" -Encoding utf8

# Install react-scripts for running the app
npm install --save-dev react-scripts

Write-Green "✅ React project setup complete!"
Write-Yellow "To run the project:"
Write-Yellow "  npm start"
Write-Yellow "To lint the project:"
Write-Yellow "  npm run lint"
Write-Yellow "To format the project code:"
Write-Yellow "  npm run format"
Write-Blue "Your AstroVim React integration should now work properly with this project." 
# JavaScript Integration for AstroVim

This configuration adds comprehensive JavaScript support to AstroVim, including:

- TypeScript Server (tsserver) for intelligent code completion and analysis
- Prettier and ESLint for formatting and linting
- Treesitter for enhanced syntax highlighting
- Custom snippets for JavaScript, TypeScript, and React
- Debugging support for Node.js and browser applications

## Features

- **Syntax Highlighting**: Enhanced JavaScript/TypeScript syntax highlighting via Treesitter
- **Intelligent Code Completion**: Context-aware code suggestions from tsserver
- **Automatic Formatting**: Format-on-save with Prettier
- **Linting**: Real-time error checking with ESLint
- **Snippets**: Productivity-boosting code snippets for common JS patterns
- **Debugging**: Integrated debugging for Node.js and browser JavaScript

## Included Tools

The following tools are automatically installed via Mason:

- **Language Server**: tsserver
- **Formatters**: prettierd, eslint_d
- **Debug Adapter**: js-debug-adapter
- **Treesitter Parsers**: javascript, typescript, tsx, html, css, json

## Keyboard Shortcuts

AstroVim's standard LSP shortcuts work with JavaScript files:

- `gd` - Go to definition
- `gr` - Go to references
- `K` - Show hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>lf` - Format document

For debugging (requires setting up a launch configuration):

- `<leader>dc` - Continue/start debugging
- `<leader>db` - Toggle breakpoint
- `<leader>dt` - Terminate debug session

## Snippets

This integration includes snippets for common JavaScript patterns. Some examples:

- `log` → `console.log();`
- `fn` → Function declaration
- `afn` → Arrow function
- `imp` → Import statement
- `rcomp` → React component
- `uef` → useEffect hook
- `ust` → useState hook

## Configuration

The JavaScript configuration is already set up and ready to use. If you want to customize it further, you can modify:

- `lua/user/plugins/javascript.lua`: Main JavaScript configuration
- `lua/user/plugins/cmp.lua`: Completion configuration
- `lua/user/plugins/debug.lua`: Debug adapter configuration
- `snippets/javascript/`: Custom JavaScript snippets

## Requirements

For debugging to work properly, you need to have Node.js installed on your system.

For full ESLint and Prettier functionality, you should have project-specific configurations (`.eslintrc`, `.prettierrc`) in your project root.

## Usage

Just open any JavaScript, TypeScript, JSX, or TSX file, and all the features will be automatically activated.

For the best experience, make sure your project has proper configuration files for ESLint and Prettier. 
# React Integration for AstroVim

This configuration enhances AstroVim with robust React development capabilities, including syntax highlighting, code suggestions, autocompletion, and snippets.

## Features

- **Syntax Highlighting:** Enhanced syntax highlighting for JavaScript, TypeScript, JSX, and TSX
- **Code Suggestions:** Intelligent code suggestions for React components and hooks
- **Autocompletion:** Advanced autocompletion for React code with TypeScript support
- **Snippets:** Pre-configured React snippets for common patterns
- **Formatting:** Auto-formatting on save with Prettier and ESLint
- **LSP Integration:** TypeScript Server (tsserver) with React-specific configurations
- **Auto Close Tags:** Automatically closes JSX/HTML tags

## Installed Tools

- **Language Servers:**
  - tsserver (TypeScript/JavaScript)
  - cssls (CSS)
  - html (HTML)
  - emmet_ls (Emmet)
  - tailwindcss (Tailwind CSS)

- **Formatters/Linters:**
  - prettierd (Prettier daemon)
  - eslint (ESLint for JavaScript/TypeScript)
  - stylelint (CSS linting)
  - jsonlint (JSON linting)

- **Treesitter Parsers:**
  - javascript, typescript, tsx
  - html, css, json
  - jsdoc, scss, graphql, regex

## Keybindings

### React-Specific Keybindings

| Key Combination | Action | Description |
|----------------|--------|-------------|
| `<leader>rc`   | Add Missing Imports | Adds any missing imports to the current file |
| `<leader>rf`   | Fix All TypeScript Diagnostics | Fixes all TypeScript errors in the current file |
| `<leader>ro`   | Organize Imports | Organizes and sorts imports in the current file |

### Standard LSP Keybindings

| Key Combination | Action |
|----------------|--------|
| `gd`           | Go to Definition |
| `gr`           | Go to References |
| `K`            | Show Hover Documentation |
| `<leader>ca`   | Code Actions |
| `<leader>rn`   | Rename Symbol |
| `<leader>lf`   | Format Document |

## Snippets

This configuration includes many useful React snippets:

| Prefix | Description |
|--------|-------------|
| `rfc`  | React Functional Component |
| `rfcp` | React Functional Component with Props Interface |
| `usestate` | React useState Hook |
| `useeffect` | React useEffect Hook |
| `usecontext` | React useContext Hook |
| `useref` | React useRef Hook |
| `usememo` | React useMemo Hook |
| `usecallback` | React useCallback Hook |
| `fragment` | React Fragment |
| `imr` | Import React |
| `imrc` | Import React, { Component } |
| `imrh` | Import React with Hooks |

## Installation & Verification

1. **Install Dependencies:**
   ```
   nvim -c "luafile install-react-support.lua"
   ```
   This will install all necessary language servers, linters, and parsers.

2. **Verify Installation:**
   ```
   nvim -c "luafile verify-react-setup.lua"
   ```
   This script will check if all required components are properly installed.

3. **Setup a New React Project:**
   - For Windows:
     ```
     .\setup-react-project.ps1
     ```
   - For Linux/Mac:
     ```
     ./setup-react-project.sh
     ```
   These scripts will set up a complete React project with TypeScript and proper ESLint/Prettier configurations to ensure AstroVim's React integration works correctly.

## Usage

1. **Starting a New React Project:**
   - Create your project files as usual
   - AstroVim will automatically detect JSX/TSX files and apply the appropriate syntax highlighting

2. **Using Snippets:**
   - In a JavaScript/TypeScript file, type one of the snippet prefixes (e.g., `rfc`)
   - Press `<Tab>` to expand the snippet

3. **Auto-importing:**
   - When you use a React component or hook, tsserver will offer to auto-import it
   - Use `<leader>rc` to add all missing imports to the current file

4. **Formatting:**
   - Files will be formatted automatically on save
   - You can also manually format with `<leader>lf`

5. **Checking Errors:**
   - TypeScript errors will be shown in the editor
   - Use `<leader>rf` to fix all fixable TypeScript errors

## Troubleshooting

If you encounter any issues:

1. Ensure all language servers are installed:
   - `:Mason` and check that all required servers are installed
   - If not, click on any missing server to install it

2. Update treesitter parsers:
   - `:TSUpdate` to update all parsers
   - `:TSInstall javascript typescript tsx html css` to manually install parsers

3. Run the verification script to identify missing dependencies:
   - `:luafile verify-react-setup.lua`

4. **ESLint Integration Issues:**
   - If you see errors like `null-ls failed to load builtin eslint for method code_actions/formatting/diagnostics`:
     1. Make sure you have a proper ESLint configuration in your project
     2. The verify script should have created a basic `.eslintrc.json` file in your workspace
     3. Check if either `eslint` or `eslint_d` is installed in Mason (`:Mason`)
     4. For large projects, consider installing ESLint and its plugins locally:
        ```
        npm init -y
        npm install eslint --save-dev
        npx eslint --init
        ```
     5. Run `:checkhealth null-ls` to see if null-ls can detect your ESLint installation

5. **null-ls Errors:**
   - If you see errors like `attempt to index field 'eslint' (a nil value)` or other null-ls errors:
     1. **Automatic Fix**: Run the all-in-one fixer script:
        ```
        :luafile fix-null-ls-issues.lua
        ```
        This script will automatically:
        - Update your none-ls.lua with safer error handling
        - Install the custom null-ls implementation
        - Ensure an ESLint configuration exists
        - Ensure ESLint is installed
     
     2. If you prefer to fix manually:
        - The custom null-ls implementation in `lua/user/plugins/null-ls-custom.lua` should help fix these issues
        - This implementation has better error handling and fallbacks for when builtins aren't available
        - Run `:Lazy sync` to ensure the plugin is loaded
        - If you're still seeing errors, try installing eslint globally: `npm install -g eslint`

6. **prettier/prettierd Issues:**
   - If formatting isn't working as expected:
     1. Install prettier locally in your project: `npm install --save-dev prettier`
     2. Create a `.prettierrc.json` file in your project root with your preferred formatting options
     3. Run `:checkhealth null-ls` to verify Prettier is detected

7. **Project-Specific Setup:**
   - For React projects, initialize a proper project with both ESLint and Prettier:
     ```
     npm init -y
     npm install react react-dom
     npm install --save-dev eslint prettier eslint-plugin-react eslint-config-prettier
     ```
   - Alternatively, use the included setup scripts:
     - For Windows: `.\setup-react-project.ps1`
     - For Linux/Mac: `./setup-react-project.sh`

8. Restart Neovim if changes don't take effect immediately

### Resolving the "attempt to index field 'eslint' (a nil value)" Error

If you're seeing the error `attempt to index field 'eslint' (a nil value)` or `null-ls failed to load builtin eslint`, follow these steps:

1. **Direct fix - Simplify none-ls.lua**:
   - Open the file `lua/plugins/none-ls.lua`
   - Replace all content with:
   ```lua
   -- Simplified none-ls config to avoid errors
   return {
     "nvimtools/none-ls.nvim",
     opts = function(_, opts)
       -- Empty configuration that won't cause errors
       return opts
     end,
   }
   ```

2. **Add Custom null-ls Implementation**:
   - Create a file at `lua/user/plugins/null-ls-custom.lua`
   - Add the following content:
   ```lua
   return {
     "nvimtools/none-ls.nvim",
     event = { "BufReadPre", "BufNewFile" },
     config = function()
       -- Safely require null-ls
       local ok, null_ls = pcall(require, "null-ls")
       if not ok then return end
       
       -- Safe source setup
       local sources = {}
       null_ls.setup({ sources = sources })
     end,
   }
   ```

3. **Restart Neovim** after making these changes.

Both of these files have been created for you already. You just need to restart Neovim for the changes to take effect.

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.o.foldmethod = "manual" -- Or 'indent' or 'syntax'
    vim.o.foldenable = false
    -- You might need a UFO-specific command if the error persists
    -- pcall(vim.cmd, [[ UfoDisable ]]) 
  end,
}) 
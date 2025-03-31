-- React Support Installation Script for AstroVim
-- This script installs all necessary dependencies for React development in AstroVim

local function notify(msg, level)
  level = level or vim.log.levels.INFO
  vim.notify(msg, level, { title = "React Support Installer" })
end

-- Install Mason packages
local function install_mason_packages()
  notify("Installing Mason packages for React development...")
  
  local required_lsp_servers = {
    "tsserver",
    "cssls", 
    "html",
    "emmet_ls",
    "tailwindcss"
  }
  
  -- Try both eslint and eslint_d
  local required_tools = {
    "prettierd",
    "eslint",
    "eslint_d",
    "stylelint",
    "jsonlint"
  }
  
  local registry_avail, registry = pcall(require, "mason-registry")
  if not registry_avail then
    notify("Mason registry not available. Please make sure Mason is installed.", vim.log.levels.ERROR)
    return false
  end
  
  -- Install required LSP servers
  for _, server in ipairs(required_lsp_servers) do
    if registry.is_installed(server) then
      notify("LSP server already installed: " .. server)
    else
      local server_pkg = registry.get_package(server)
      notify("Installing LSP server: " .. server)
      server_pkg:install()
    end
  end
  
  -- Install required tools
  for _, tool in ipairs(required_tools) do
    if registry.is_installed(tool) then
      notify("Tool already installed: " .. tool)
    else
      -- Try to install but don't fail if it doesn't exist
      pcall(function()
        local tool_pkg = registry.get_package(tool)
        notify("Installing tool: " .. tool)
        tool_pkg:install()
      end)
    end
  end
  
  return true
end

-- Check and create ESLint config if needed
local function ensure_eslint_config()
  local fs = vim.loop or vim.uv
  local found = false
  
  -- Check for existing eslint config
  local eslint_configs = {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json"
  }
  
  for _, config in ipairs(eslint_configs) do
    if fs.fs_stat(config) then
      found = true
      notify("Found ESLint config: " .. config)
      break
    end
  end
  
  -- Create basic ESLint config if not found
  if not found then
    notify("No ESLint config found. Creating a basic .eslintrc.json", vim.log.levels.WARN)
    local eslint_config = [[{
  "env": {
    "browser": true,
    "es2021": true,
    "node": true
  },
  "extends": [
    "eslint:recommended"
  ],
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module",
    "ecmaFeatures": {
      "jsx": true
    }
  },
  "rules": {
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
  }
}]]
    
    local fd = assert(io.open(".eslintrc.json", "w"))
    fd:write(eslint_config)
    fd:close()
    notify("Created .eslintrc.json in the current directory")
  end
  
  return true
end

-- Install Treesitter parsers
local function install_treesitter_parsers()
  notify("Installing Treesitter parsers for React development...")
  
  local required_parsers = {
    "javascript",
    "typescript",
    "tsx",
    "html",
    "css",
    "json",
    "jsdoc",
    "scss",
    "graphql",
    "regex"
  }
  
  local ts_avail, ts = pcall(require, "nvim-treesitter.install")
  if not ts_avail then
    notify("Treesitter not available. Please make sure nvim-treesitter is installed.", vim.log.levels.ERROR)
    return false
  end
  
  for _, parser in ipairs(required_parsers) do
    notify("Installing Treesitter parser: " .. parser)
    vim.cmd("TSInstall " .. parser)
  end
  
  return true
end

-- Main installation function
local function install_react_support()
  notify("Starting React support installation for AstroVim...")
  
  -- Check if required plugins are available
  local required_plugins = {
    "mason.nvim",
    "nvim-treesitter",
    "nvim-lspconfig",
    "typescript.nvim"
  }
  
  for _, plugin in ipairs(required_plugins) do
    if not pcall(require, plugin) then
      notify("Required plugin not found: " .. plugin .. ". Please make sure it's installed.", vim.log.levels.ERROR)
      return
    end
  end
  
  -- Install dependencies
  local mason_success = install_mason_packages()
  local treesitter_success = install_treesitter_parsers()
  local eslint_success = ensure_eslint_config()
  
  if mason_success and treesitter_success and eslint_success then
    notify("React support installation completed successfully!", vim.log.levels.INFO)
    notify("Please restart AstroVim for all changes to take effect.", vim.log.levels.WARN)
  else
    notify("React support installation completed with some issues. Check the logs for details.", vim.log.levels.WARN)
  end
end

-- Run the installation
install_react_support() 
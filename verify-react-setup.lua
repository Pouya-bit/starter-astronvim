-- React Support Verification Script for AstroVim
-- This script checks if all necessary dependencies for React development are installed correctly

local function notify(msg, level)
  level = level or vim.log.levels.INFO
  vim.notify(msg, level, { title = "React Support Verification" })
end

-- Check Mason packages
local function check_mason_packages()
  notify("Checking Mason packages for React development...")
  
  local required_lsp_servers = {
    "tsserver",
    "cssls", 
    "html",
    "emmet_ls",
    "tailwindcss"
  }
  
  local required_tools = {
    "prettierd",
    "eslint",
    "stylelint",
    "jsonlint"
  }
  
  local registry_avail, registry = pcall(require, "mason-registry")
  if not registry_avail then
    notify("Mason registry not available. Please make sure Mason is installed.", vim.log.levels.ERROR)
    return false
  end
  
  local all_installed = true
  local missing_packages = {}
  
  -- Check required LSP servers
  for _, server in ipairs(required_lsp_servers) do
    if not registry.is_installed(server) then
      all_installed = false
      table.insert(missing_packages, "LSP: " .. server)
    end
  end
  
  -- Check required tools - at least one of eslint or eslint_d must be installed
  local has_eslint = registry.is_installed("eslint")
  local has_eslint_d = registry.is_installed("eslint_d")
  
  if not (has_eslint or has_eslint_d) then
    all_installed = false
    table.insert(missing_packages, "Tool: eslint or eslint_d")
  end
  
  -- Check other tools
  for _, tool in ipairs(required_tools) do
    if tool ~= "eslint" and not registry.is_installed(tool) then
      all_installed = false
      table.insert(missing_packages, "Tool: " .. tool)
    end
  end

  if not all_installed then
    notify("Missing Mason packages:\n" .. table.concat(missing_packages, "\n"), vim.log.levels.WARN)
    notify("Run :Mason to install missing packages", vim.log.levels.INFO)
  else
    notify("All required Mason packages are installed!", vim.log.levels.INFO)
  end
  
  return all_installed
end

-- Check ESLint configuration
local function check_eslint_config()
  notify("Checking ESLint configuration...")
  
  local fs = vim.loop or vim.uv
  local eslint_configs = {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json"
  }
  
  local found = false
  local config_path = ""
  
  for _, config in ipairs(eslint_configs) do
    if fs.fs_stat(config) then
      found = true
      config_path = config
      break
    end
  end
  
  if found then
    notify("Found ESLint configuration: " .. config_path, vim.log.levels.INFO)
  else
    notify("No ESLint configuration found. This is required for ESLint to work properly.", vim.log.levels.WARN)
    notify("Creating a basic .eslintrc.json file...", vim.log.levels.INFO)
    
    -- Create a basic eslint config
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
    found = true
  end
  
  return found
end

-- Check Treesitter parsers
local function check_treesitter_parsers()
  notify("Checking Treesitter parsers for React development...")
  
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
  
  local ts_avail, ts = pcall(require, "nvim-treesitter.parsers")
  if not ts_avail then
    notify("Treesitter not available. Please make sure nvim-treesitter is installed.", vim.log.levels.ERROR)
    return false
  end
  
  local all_installed = true
  local missing_parsers = {}
  
  for _, parser in ipairs(required_parsers) do
    if not ts.has_parser(parser) then
      all_installed = false
      table.insert(missing_parsers, parser)
    end
  end
  
  if not all_installed then
    notify("Missing Treesitter parsers:\n" .. table.concat(missing_parsers, "\n"), vim.log.levels.WARN)
    local install_cmd = ":TSInstall " .. table.concat(missing_parsers, " ")
    notify("Run " .. install_cmd .. " to install missing parsers", vim.log.levels.INFO)
  else
    notify("All required Treesitter parsers are installed!", vim.log.levels.INFO)
  end
  
  return all_installed
end

-- Check plugins
local function check_plugins()
  notify("Checking required plugins...")
  
  local required_plugins = {
    "mason.nvim",
    "nvim-treesitter",
    "nvim-lspconfig",
    "typescript.nvim",
    "null-ls"
  }
  
  local all_installed = true
  local missing_plugins = {}
  
  for _, plugin in ipairs(required_plugins) do
    if not pcall(require, plugin) then
      all_installed = false
      table.insert(missing_plugins, plugin)
    end
  end
  
  if not all_installed then
    notify("Missing plugins:\n" .. table.concat(missing_plugins, "\n"), vim.log.levels.WARN)
  else
    notify("All required plugins are installed!", vim.log.levels.INFO)
  end
  
  return all_installed
end

-- Check if null-ls is loading without errors
local function check_null_ls()
  notify("Checking null-ls configuration...")
  
  local null_ls_ok, null_ls = pcall(require, "null-ls")
  if not null_ls_ok then
    notify("null-ls is not properly loaded. Check your null-ls configuration.", vim.log.levels.ERROR)
    return false
  end
  
  local sources = null_ls.get_sources()
  if #sources == 0 then
    notify("No null-ls sources configured. This might indicate a configuration issue.", vim.log.levels.WARN)
    notify("Consider using the custom null-ls implementation in lua/user/plugins/null-ls-custom.lua", vim.log.levels.INFO)
    return false
  end
  
  local source_names = {}
  for _, source in ipairs(sources) do
    if source.name then
      table.insert(source_names, source.name)
    end
  end
  
  notify("Active null-ls sources: " .. table.concat(source_names, ", "), vim.log.levels.INFO)
  
  -- Check if eslint builtins are available
  local eslint_builtins_ok = true
  
  local has_eslint_code_actions = pcall(function() return null_ls.builtins.code_actions.eslint end)
  local has_eslint_formatting = pcall(function() return null_ls.builtins.formatting.eslint end)
  local has_eslint_diagnostics = pcall(function() return null_ls.builtins.diagnostics.eslint end)
  
  if not (has_eslint_code_actions and has_eslint_formatting and has_eslint_diagnostics) then
    eslint_builtins_ok = false
    notify("Some eslint builtins are missing from null-ls!", vim.log.levels.WARN)
    notify("This could cause errors when loading null-ls. Consider using the custom implementation.", vim.log.levels.INFO)
  end
  
  -- Check if the custom null-ls implementation exists
  local fs = vim.loop or vim.uv
  local custom_null_ls_path = "lua/user/plugins/null-ls-custom.lua"
  local has_custom_null_ls = fs.fs_stat(custom_null_ls_path) ~= nil
  
  if not eslint_builtins_ok and not has_custom_null_ls then
    notify("Recommended action: Use the custom null-ls implementation to avoid errors.", vim.log.levels.WARN)
    return false
  elseif not eslint_builtins_ok and has_custom_null_ls then
    notify("Custom null-ls implementation found. This should help avoid eslint errors.", vim.log.levels.INFO)
  end
  
  return true
end

-- Main verification function
local function verify_react_support()
  notify("Starting React support verification for AstroVim...")
  
  local plugins_check = check_plugins()
  local mason_check = check_mason_packages()
  local treesitter_check = check_treesitter_parsers()
  local eslint_check = check_eslint_config()
  local null_ls_check = check_null_ls()
  
  if plugins_check and mason_check and treesitter_check and eslint_check and null_ls_check then
    notify("React support verification completed successfully!", vim.log.levels.INFO)
    notify("Your AstroVim is ready for React development!", vim.log.levels.INFO)
  else
    notify("React support verification completed with some issues. Check the logs for details.", vim.log.levels.WARN)
    notify("See REACT-README.md for troubleshooting guidance.", vim.log.levels.INFO)
  end
end

-- Run the verification
verify_react_support() 
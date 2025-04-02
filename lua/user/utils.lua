-- Utility script to manage missing system tools
-- This is used to automatically install missing utilities for AstroNvim

local M = {}

-- Check if command exists
M.command_exists = function(cmd)
  local handle = io.popen('where ' .. cmd .. ' 2>&1')
  if not handle then return false end
  
  local result = handle:read("*a")
  handle:close()
  
  return not result:match("not found") and not result:match("Could not find")
end

-- Detect package manager
M.detect_package_manager = function()
  local package_managers = {
    { name = "scoop", check_cmd = "scoop", install_cmd = "scoop install" },
    { name = "chocolatey", check_cmd = "choco", install_cmd = "choco install -y" },
    { name = "winget", check_cmd = "winget", install_cmd = "winget install" },
  }
  
  for _, pm in ipairs(package_managers) do
    if M.command_exists(pm.check_cmd) then
      return pm.name, pm.install_cmd
    end
  end
  
  return nil, nil
end

-- Install a package using the appropriate package manager
M.install_package = function(package_name)
  local pm_name, pm_cmd = M.detect_package_manager()
  
  if pm_name and pm_cmd then
    local handle = io.popen(pm_cmd .. " " .. package_name .. " 2>&1")
    if handle then
      local result = handle:read("*a")
      handle:close()
      vim.notify("Installed " .. package_name .. " using " .. pm_name, vim.log.levels.INFO)
      return true
    end
  end
  
  vim.notify("Failed to install " .. package_name .. ". Please install it manually.", vim.log.levels.ERROR)
  return false
end

-- Install missing AstroNvim utilities
M.install_missing_utils = function()
  local missing_utils = {}
  
  -- Check for gdu (disk usage analyzer)
  if not M.command_exists("gdu") and not M.command_exists("gdu_windows_amd64") then
    table.insert(missing_utils, "gdu")
  end
  
  -- Check for btm (system monitor)
  if not M.command_exists("btm") then
    table.insert(missing_utils, "bottom")
  end
  
  -- Install missing utilities
  for _, util in ipairs(missing_utils) do
    M.install_package(util)
  end
end

-- Install tree-sitter
M.install_tree_sitter_cli = function()
  if not M.command_exists("tree-sitter") then
    local npm_exists = M.command_exists("npm")
    
    if npm_exists then
      local handle = io.popen("npm install -g tree-sitter-cli 2>&1")
      if handle then
        local result = handle:read("*a")
        handle:close()
        vim.notify("Installed tree-sitter CLI using npm", vim.log.levels.INFO)
        return true
      end
    else
      vim.notify("npm not found. Please install Node.js to use tree-sitter CLI", vim.log.levels.WARN)
    end
    
    return false
  end
  
  return true
end

-- Install jsonc parser for nvim-treesitter
M.install_jsonc_parser = function()
  if vim.fn.executable('git') == 1 then
    local has_treesitter, ts = pcall(require, 'nvim-treesitter.parsers')
    if has_treesitter then
      if not ts.has_parser('jsonc') then
        vim.cmd('TSInstall jsonc')
        vim.notify("Installed jsonc parser for treesitter", vim.log.levels.INFO)
      end
    end
  end
end

return M 
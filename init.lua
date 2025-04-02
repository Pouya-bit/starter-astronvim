-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

-- Load compatibility fixes for deprecated functions
require "user.lsp_compat"

require "lazy_setup"
require "polish"

-- Load and execute utils to fix missing dependencies
vim.defer_fn(function()
  local has_utils, utils = pcall(require, "user.utils")
  if has_utils then
    utils.install_missing_utils()
    utils.install_tree_sitter_cli()
    utils.install_jsonc_parser()
  end
end, 3000) -- delay for 3 seconds before attempting to install

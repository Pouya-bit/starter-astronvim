return {
  -- Add specific React plugins and configurations
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure emmet works well with JSX
        emmet_ls = {
          filetypes = {
            "html",
            "javascriptreact",
            "typescriptreact",
            "jsx",
            "tsx",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Add JSX/TSX specific highlights
      if opts.highlight then
        opts.highlight.disable = { "tsx", "jsx" } -- First disable default highlight for these
      end
      vim.treesitter.language.register('javascript', 'javascriptreact') -- Register JSX as JavaScript
      vim.treesitter.language.register('typescript', 'typescriptreact') -- Register TSX as TypeScript
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    enabled = true,
    opts = { mode = "cursor", max_lines = 3 },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = true,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        javascript = { "template_string" },
        typescript = { "template_string" },
        javascriptreact = { "template_string" },
        typescriptreact = { "template_string" },
      },
    },
  },
} 
-- ~/.config/nvim/lua/plugins.lua
-- Lista de plugins + configs essenciais (inclui colorscheme, LSP, formatador)

return {
  -- Tema (carrega primeiro)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin"
    end,
  },

  -- Qualidade de vida
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {}, -- instale sob demanda
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  { "numToStr/Comment.nvim", config = true },
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "nvim-telescope/telescope.nvim", tag = "0.1.8", opts = {} },

  -- Formatador simples
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = { timeout_ms = 1500 },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        sh = { "shfmt" },
      },
    },
  },

  -- LSP (Mason + LSPConfig com auto-setup)
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", build = ":MasonUpdate" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    -- bloco de config que liga tudo do LSP
    "_lsp-setup",
    lazy = false,
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup({ ensure_installed = {} })

      local lspconfig = require('lspconfig')
      local on_attach = function(_, bufnr)
        local function bufmap(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        bufmap('n','gd', vim.lsp.buf.definition, 'Goto Definition')
        bufmap('n','K',  vim.lsp.buf.hover,      'Hover')
        bufmap('n','gr', vim.lsp.buf.references, 'References')
        bufmap('n','<leader>rn', vim.lsp.buf.rename, 'Rename')
      end

      -- Auto-configura qualquer servidor instalado via :Mason
      require('mason-lspconfig').setup_handlers({
        function(server)
          lspconfig[server].setup({ on_attach = on_attach })
        end,
      })

      -- Exemplos (ative se quiser fixar):
      -- lspconfig.lua_ls.setup({ on_attach = on_attach })
      -- lspconfig.pyright.setup({ on_attach = on_attach })
    end,
  },
}
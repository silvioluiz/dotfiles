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
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Ativa o mason, que gerencia os LSPs
      require('mason').setup()

      local lspconfig = require('lspconfig')

      -- Função a ser executada quando um servidor LSP se anexa a um buffer
      local on_attach = function(_, bufnr)
        local function bufmap(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        -- Mapeamentos de atalhos do LSP
        bufmap('n', 'gd', vim.lsp.buf.definition, 'Goto Definition')
        bufmap('n', 'K',  vim.lsp.buf.hover,      'Hover')
        bufmap('n', 'gr', vim.lsp.buf.references, 'References')
        bufmap('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
        bufmap('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
      end

      -- Combina a configuração do mason-lspconfig em uma única chamada `setup`
      require('mason-lspconfig').setup({
        -- Lista de servidores para garantir que estejam instalados.
        -- Deixe vazio para instalar sob demanda. Ex: { "lua_ls", "pyright" }
        ensure_installed = {},
        -- A nova sintaxe usa uma tabela 'handlers'
        handlers = {
          -- O handler padrão será chamado para cada servidor instalado
          function(server_name)
            lspconfig[server_name].setup({
              on_attach = on_attach,
            })
          end,
        },
      })
    end,
  },
}

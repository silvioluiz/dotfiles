-- ~/.config/nvim/init.lua
-- Perfil leve: bootstrap lazy.nvim + opções/atalhos

local fn = vim.fn
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  fn.system({
    "git","clone","--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git","--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Opções básicas
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.updatetime = 200

-- Atalhos básicos (Telescope sob demanda)
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc })
end
map('n','<leader>ff', function() require('telescope.builtin').find_files() end, 'Find files')
map('n','<leader>fg', function() require('telescope.builtin').live_grep()  end, 'Live grep')

-- Plugins
require('lazy').setup(require('plugins'))
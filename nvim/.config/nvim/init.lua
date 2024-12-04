-- ~/.config/nvim/init.lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Configuration
require("lazy").setup({
  -- Pencarian
  {
    'nvim-telescope/telescope.nvim', 
    dependencies = { 
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim'
    },
    config = function()
      require('telescope').setup{
        defaults = {
          file_ignore_patterns = {"node_modules"},
         mappings = {
            i = {
              ["<C-j>"] = require('telescope.actions').move_selection_next,
              ["<C-k>"] = require('telescope.actions').move_selection_previous
            }
          }
        }
      }
      -- Keymaps untuk pencarian
      vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', {noremap = true, silent = true})
      vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', {noremap = true, silent = true})
    end
  },

  -- Syntax Highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {"lua", "python", "javascript", "typescript", "rust"},
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        }
      }
    end
  },

  -- Terminal Terintegrasi
  {
    'akinsho/toggleterm.nvim', 
    version = "*", 
    config = function()
      require("toggleterm").setup{
        open_mapping = [[<c-\>]],
        direction = 'float'
      }
    end
  },

  -- LSP Support
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      {'neovim/nvim-lspconfig'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/nvim-cmp'},
      {'L3MON4D3/LuaSnip'},
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.preset("recommended")
      lsp_zero.setup()
    end
  }
})

-- Pengaturan Umum
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.g.mapleader = ' '

-- Tema (opsional)
vim.cmd('colorscheme torte')
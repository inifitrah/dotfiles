return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}

    local api = require("nvim-tree.api")
    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    -- Add key mappings
    vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
    vim.keymap.set('n', '<leader>f', ':NvimTreeFocus<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', { noremap = true, silent = true })
  end,
}

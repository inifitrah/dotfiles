return {
  "folke/zen-mode.nvim",
  keys = {
    {
      "<leader>z",
      "<cmd>ZenMode<CR>",
      desc = "Toggle Zen Mode",
    },
  },
  opts = {
    window = {
            width = 100,
    },
    on_open = function()
        vim.wo.wrap = true
        vim.wo.linebreak = true
        vim.wo.breakindent = true
      end,
      on_close = function()
        vim.wo.wrap = false
        vim.wo.linebreak = false
        vim.wo.breakindent = false
      end,
  },
}

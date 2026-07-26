return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = 15,
    open_mapping = "<C-\\>",
    direction = "horizontal",
    shade_terminals = true,
    start_in_insert = true,
  },
  keys = {
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", desc = "Terminal vertical" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<CR>", desc = "Terminal float" },
  },
}

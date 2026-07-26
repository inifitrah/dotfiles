return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>sf", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    { "<C-A-\\>", "<cmd>Telescope colorscheme<CR>", desc = "Theme picker" },
  },
  opts = {
    pickers = {
      colorscheme = { enable_preview = true },
    },
  },
}

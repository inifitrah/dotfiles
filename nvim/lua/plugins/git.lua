return {
  "lewis6991/gitsigns.nvim",
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local map = vim.keymap.set
      map("n", "]h", gs.next_hunk, { buffer = bufnr, desc = "Next hunk" })
      map("n", "[h", gs.prev_hunk, { buffer = bufnr, desc = "Prev hunk" })
      map("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
      map("n", "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
    end,
  },
}

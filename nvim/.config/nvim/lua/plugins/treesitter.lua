return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = {
      "javascript", "lua", "typescript", "python", "html" -- Bahasa yang dibutuhkan
    },
    highlight = {
      enable = true, -- Pastikan ini diaktifkan
    },
    indent = { enable = true },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}

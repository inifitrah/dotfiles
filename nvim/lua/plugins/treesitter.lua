return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()

    local parsers = {
      "lua", "vim", "vimdoc",
      "luau",
      "javascript", "typescript", "tsx",
      "html", "css", "json", "markdown", "bash",
    }
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = parsers,
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}

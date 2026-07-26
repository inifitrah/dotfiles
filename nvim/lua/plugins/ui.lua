local colorscheme_file = vim.fn.stdpath("data") .. "/colorscheme"

-- Auto-save colorscheme tiap kali ganti
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local file = io.open(colorscheme_file, "w")
    if file then
      file:write('return "' .. vim.g.colors_name .. '"')
      file:close()
    end
  end,
})

-- Load saved colorscheme, fallback ke default
local function load_colorscheme()
  local ok, name = pcall(dofile, colorscheme_file)
  vim.cmd.colorscheme(ok and name or "tokyonight-night")
end

return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = load_colorscheme,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = { flavour = "mocha" },
  },
  {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    opts = { theme = "wave" },
  },
  {
    "tiagovla/tokyodark.nvim",
    priority = 1000,
    opts = { transparent_background = false },
  },
  {
    "AlexvZyl/nordic.nvim",
    priority = 1000,
    opts = { transparent_background = false },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
    },
  },
}

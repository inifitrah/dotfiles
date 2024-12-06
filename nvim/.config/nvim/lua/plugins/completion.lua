return { {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",     -- Integrasi dengan LSP
    "hrsh7th/cmp-buffer",       -- Saran dari buffer aktif
    "hrsh7th/cmp-path",         -- Saran untuk file path
    "hrsh7th/cmp-cmdline",      -- Saran untuk command line
    "L3MON4D3/LuaSnip",         -- Snippet Engine
    "saadparwaiz1/cmp_luasnip", -- Integrasi LuaSnip dengan cmp
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- Gunakan LuaSnip untuk snippet
        end,
      },
      mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- Saran dari LSP
        { name = "luasnip" },  -- Saran dari snippet
        { name = "buffer" },   -- Saran dari buffer aktif
        { name = "path" },     -- Saran dari file path
      }),
    })

    -- Konfigurasi untuk cmdline (opsional)
    cmp.setup.cmdline("/", {
      sources = {
        { name = "buffer" }
      }
    })
    cmp.setup.cmdline(":", {
      sources = cmp.config.sources({
        { name = "path" }
      }, {
        { name = "cmdline" }
      })
    })
  end,
},
  {
    "windwp/nvim-autopairs",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      require("nvim-autopairs").setup({})
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt" },
    },
  } }

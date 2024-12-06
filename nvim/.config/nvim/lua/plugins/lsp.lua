return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim", -- Integrasi Mason dan LSPConfig
    "neovim/nvim-lspconfig",
    {
      "hrsh7th/nvim-cmp",       -- Auto-completion plugin
      dependencies = {
        "hrsh7th/cmp-nvim-lsp", -- Integrasi nvim-cmp dengan LSP
      },
    },                          -- Plugin utama untuk LSP
  },
  config = function()
    require("mason").setup({})
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "cssls",
        "html",
        "emmet_ls",
        "ts_ls",
        "svelte",
        -- "stylua",
      },
      automatic_installation = true,
    })

    local lspconfig = require("lspconfig")
    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      -- Keybindings untuk fitur LSP seperti go-to-definition, rename, dll.
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true }) -- Format kode menggunakan LSP
      end, opts)
    end
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        lspconfig[server_name].setup({
          on_attach = on_attach,
          capabilities = capabilities
        })
      end,
    })
  end

}

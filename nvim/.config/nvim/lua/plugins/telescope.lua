return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local telescope = require('telescope')
        local builtin = require('telescope.builtin')

        -- Key mappings
        vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files({hidden: true})<cr>',
            { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<cr>',
            { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>',
            { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>',
            { noremap = true, silent = true })
         vim.api.nvim_set_keymap('n', '<leader>fz', '<cmd>Telescope current_buffer_fuzzy_find <CR>',
            { noremap = true, silent = true })
  end,
}

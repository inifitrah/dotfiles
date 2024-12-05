return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = {
    { 'juansalvatore/git-dashboard-nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  },
  opts = function()
    local git_dashboard = require('git-dashboard-nvim').setup {
      show_only_weeks_with_commits = true,
      colors = {
        days_and_months_labels = '#87CEEB',
        empty_square_highlight = '#87CEEB',
        filled_square_highlights = { '#87CEEB', '#87CEEB', '#87CEEB', '#87CEEB', '#87CEEB', '#87CEEB' },
        branch_highlight = '#87CEEB',
        dashboard_title = '#87CEEB',
      },
    }

    local opts = {
      theme = 'doom',
      config = {
        header = git_dashboard,
        center = {
          { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
          { action = '', desc = '', icon = '', key = 'n' },
        },
        footer = function()
          return {}
        end,
      },
    }
    return opts
  end,
}

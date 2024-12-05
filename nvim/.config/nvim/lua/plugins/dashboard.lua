return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  dependencies = {
    { 'juansalvatore/git-dashboard-nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  },
  opts = function()
    local git_dashboard = require('git-dashboard-nvim').setup {
      show_only_weeks_with_commits = true,
      days = { 's', 'm', 't', 'w', 't', 'f', 's' },
      colors = {
        --catpuccin theme
        days_and_months_labels = '#8FBCBB',
        empty_square_highlight = '#88C0D0',
        filled_square_highlights = { '#88C0D0', '#88C0D0', '#88C0D0', '#88C0D0', '#88C0D0', '#88C0D0', '#88C0D0' },
        branch_highlight = '#88C0D0',
        dashboard_title = '#88C0D0',
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

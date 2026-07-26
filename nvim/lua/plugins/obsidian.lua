return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- use latest release, remove to use latest commit
    lazy = true,
    ft = "markdown",
    cmd = "Obsidian",
    dependencies = {
        "nvim-telescope/telescope.nvim",
    },
    opts = {
        legacy_commands = false, -- this will be removed in 4.0.0
        workspaces = {
            {
                name = "personal",
                path = "~/Documents/ObsidianVault",
            },
        },
        picker = {
            name = "telescope.nvim"
        }
    },
}

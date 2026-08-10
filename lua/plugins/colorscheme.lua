return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      auto_integrations = true,
      integrations = {
        snacks = {
          enabled = true,
          indent_scope_color = "lavender",
        },
        native_lsp = { enabled = true },
        mini = { enabled = true },
      },
    },
  },
  -- { "rose-pine/neovim", name = "rose-pine" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}

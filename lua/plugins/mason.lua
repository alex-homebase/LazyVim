return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      "stylelint-language-server",
      -- Roslyn language server. Not an `lspconfig` server name, so
      -- mason-lspconfig will never install it off the back of a server entry —
      -- roslyn.nvim resolves the binary out of `$MASON/bin` itself.
      "roslyn-language-server",
    },
  },
}

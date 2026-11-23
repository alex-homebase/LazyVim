return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local prettier = { "prettierd", "prettier", stop_after_first = true }

      opts.formatters_by_ft = vim.tbl_deep_extend("force", opts.formatters_by_ft or {}, {
        markdown = prettier,
        html = prettier,
        css = prettier,
        scss = prettier,
        json = prettier,
        jsonc = prettier,
        yaml = prettier,
      })

      -- The `lang.dotnet` extra points C# at csharpier. This solution has
      -- neither a .editorconfig nor a csharpier config and is edited from
      -- Visual Studio, so csharpier would rewrite whole files on the first
      -- `<leader>cf`. Roslyn's own formatter is what the IDE applies.
      opts.formatters_by_ft.cs = { lsp_format = "prefer" }
      opts.formatters_by_ft.razor = { lsp_format = "prefer" }

      opts.default_format_opts = vim.tbl_deep_extend("force", opts.default_format_opts or {}, {
        timeout_ms = 3000,
        async = true,
        lsp_format = "fallback",
      })
    end,
  },
}

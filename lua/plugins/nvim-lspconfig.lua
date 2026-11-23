return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}

    opts.servers.eslint = {
      settings = {
        format = { enable = true },
        workingDirectory = { mode = "auto" },
      },
    }

    -- mason-lspconfig still maps `stylelint_lsp` to the deprecated `stylelint-lsp`
    -- package. Skip auto-install here; the binary is provided by the
    -- `stylelint-language-server` Mason package (see plugins/mason.lua).
    opts.servers.stylelint_lsp = {
      mason = false,
      filetypes = { "css", "scss", "less", "sass", "postcss" },
    }

    -- C#/Razor is served by roslyn.nvim (see plugins/roslyn.lua), which
    -- registers the `roslyn` client itself through `vim.lsp.config`. Every
    -- other C# server has to stay off, or two of them race on the same buffer.
    -- `roslyn_ls` is the trap: mason-lspconfig auto-enables any installed
    -- server, and the `roslyn-language-server` Mason package maps to it, so
    -- installing the binary is enough to get a second Roslyn client.
    -- `csharp_ls` came from the same auto-enable. `fsautocomplete` is dropped
    -- for lack of any F# here.
    opts.servers.roslyn_ls = { enabled = false }
    opts.servers.omnisharp = { enabled = false }
    opts.servers.csharp_ls = { enabled = false }
    opts.servers.fsautocomplete = { enabled = false }

    -- Razor co-hosting forwards the HTML half of a .razor file to a client
    -- named `html` on a virtual buffer; without it Razor markup gets no
    -- completion, hover or formatting.
    opts.servers.html = {}

    opts.servers.marksman = {
      settings = {
        markdown = {
          lint = {
            config = {
              MD013 = false,
            },
          },
        },
      },
    }

    opts.servers.tailwindcss = vim.tbl_deep_extend("force", opts.servers.tailwindcss or {}, {
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              { "className\\s*[:=]\\s*[\"'`]([^\"'`]*)[\"'`]" },
              { "cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
              { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*)[\"'`]" },
              { "classNames\\s*:\\s*{([^}]*)}", "[\"'`]([^\"'`]*)[\"'`]" },
            },
          },
        },
      },
    })
  end,
}

-- C# and Razor.
--
-- The LazyVim `lang.dotnet` extra still wires up OmniSharp, which is
-- discontinued and has no Razor support at all. roslyn.nvim drives the same
-- Roslyn server the VS Code C# extension ships, and since it gained co-hosting
-- it serves `.razor` / `.cshtml` too — `rzls.nvim` is deprecated, do not add it.
--
-- The server binary is the `roslyn-language-server` Mason package (see
-- plugins/mason.lua); roslyn.nvim picks it up from `$MASON/bin` on its own.
-- Razor needs an LSP client named `html` on its virtual HTML documents, which
-- is why `html` is enabled in plugins/nvim-lspconfig.lua.
return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- Neovim's libuv watcher does not cope with a solution this size over
      -- WSL's filesystem bridge; let the server watch instead.
      filewatching = "roslyn",
    },
    init = function()
      vim.lsp.config("roslyn", {
        handlers = {
          -- Razor co-hosting answers all nine of Roslyn's pull-diagnostic
          -- providers with the same full set for a .razor document, so every
          -- warning lands in nine namespaces and renders nine times. C# files
          -- behave correctly, each provider reporting only its own category —
          -- so this narrows to Razor and keeps the compiler provider.
          -- Verified against roslyn-language-server 5.11.0-1.26380.4; drop
          -- this once the server stops fanning the set out.
          [vim.lsp.protocol.Methods.textDocument_diagnostic] = function(err, result, ctx, config)
            local uri = vim.tbl_get(ctx, "params", "textDocument", "uri") or ""
            local is_razor = uri:match("%.razor$") or uri:match("%.cshtml$")
            if is_razor and ctx.params.identifier ~= "DocumentCompilerSemantic" then
              return
            end
            return vim.lsp.diagnostic.on_diagnostic(err, result, ctx, config)
          end,
        },
        settings = {
          ["csharp|background_analysis"] = {
            -- Solutions here carry a large pre-existing warning baseline, so
            -- full-solution analysis buries the diagnostics of the file at hand.
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
          },
          ["csharp|completion"] = {
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
            dotnet_provide_regex_completions = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
          ["csharp|symbol_search"] = {
            dotnet_search_reference_assemblies = true,
          },
          ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true,
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
        },
      })
    end,
  },

  -- Only ever used by the OmniSharp `textDocument/definition` handler.
  { "Hoffs/omnisharp-extended-lsp.nvim", enabled = false },

  {
    "nvim-treesitter/nvim-treesitter",
    -- `razor` covers .razor/.cshtml, `xml` the .csproj/.sln.props files,
    -- `sql` the scripts that own the schema.
    opts = { ensure_installed = { "c_sharp", "razor", "xml", "sql" } },
  },
}

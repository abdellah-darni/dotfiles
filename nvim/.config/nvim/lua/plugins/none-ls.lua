return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier.with({
            filetypes = { "javascript", "typescript", "html", "css", "json", "markdown" }
        }),
        null_ls.builtins.formatting.black.with({
            extra_args = { "--fast" }
        }),
--        null_ls.builtins.formatting.clangformat.with({
--            command = "clang-format",
--            filetypes = {"c", "cpp", "h", "hpp"}
--        }),
--        null_ls.builtins.diagnostics.eslint_d.with({
--            only_local = "node_modules",
--            filetypes = { "javascript", "typescript" },
--        }),
        null_ls.builtins.diagnostics.pylint.with({
            filetypes = { "python" }
        }),
--        null_ls.builtins.diagnostics.shellcheck
      },
      log_level = "warn",
    })
  end,
}

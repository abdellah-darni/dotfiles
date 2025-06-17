return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
      ensure_installed = {
        "lua_ls",
        "clangd",
        "pyright",
        "jdtls",
        "html",
        "cssls",
        "ts_ls",
        "bashls",
        "tailwindcss",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_nvim_lsp.default_capabilities()
      )

      local lspconfig = require("lspconfig")

      local on_attach = function(client, bufnr)
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format { async = true }
        end, bufopts)
      end

      lspconfig.clangd.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.ts_ls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.bashls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.lua_ls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.tailwindcss.setup({ capabilities = capabilities, on_attach = on_attach })

      local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
      local jdtls_config_path = jdtls_path .. '/config_linux'

      lspconfig.jdtls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = {
          'java',
          '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
          '-Dlog.protocol=true',
          '-Dlog.level=ALL',
          '-Xmx1G',
          '--add-modules=ALL-SYSTEM',
          '--add-opens', 'java.base/java.util=ALL-UNNAMED',
          '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
          '-jar',
          vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
          '-configuration',
          jdtls_config_path,
          '-data',
          vim.fn.stdpath('data') .. '/jdtls-workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t"),
        },
        root_dir = lspconfig.util.root_pattern("pom.xml", ".git", "build.gradle", "settings.gradle"),
      })
    end,
  },
}

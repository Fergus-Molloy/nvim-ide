local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

local servers = {
  "sumneko_lua",
  "cssls",
  "html",
  "tsserver",
  "pyright",
  "bashls",
  "jsonls",
  "yamlls",
  "rust_analyzer",
  "taplo",
}

lsp_installer.setup()

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  if server == "sumneko_lua" then
    local sumneko_opts = require "user.lsp.settings.sumneko_lua"
    opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  end

  if server == "pyright" then
    local pyright_opts = require "user.lsp.settings.pyright"
    opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  end

  if server == "rust_analyzer" then
    local keymap = vim.keymap.set
    local k_opts = {silent = true, noremap = true}

    keymap("n", "<leader>rh", "<cmd>RustSetInlayHints<Cr>", k_opts)
    keymap("n", "<leader>rhd", "<cmd>RustDisableInlayHints<Cr>", k_opts)
    keymap("n", "<leader>th", "<cmd>RustToggleInlayHints<Cr>", k_opts)
    keymap("n", "<leader>rr", "<cmd>RustRunnables<Cr>", k_opts)
    keymap("n", "<leader>rem", "<cmd>RustExpandMacro<Cr>", k_opts)
    keymap("n", "<leader>roc", "<cmd>RustOpenCargo<Cr>", k_opts)
    keymap("n", "<leader>rpm", "<cmd>RustParentModule<Cr>", k_opts)
    keymap("n", "<leader>rjl", "<cmd>RustJoinLines<Cr>", k_opts)
    keymap("n", "<leader>rha", "<cmd>RustHoverActions<Cr>", k_opts)
    keymap("n", "<leader>rhr", "<cmd>RustHoverRange<Cr>", k_opts)
    keymap("n", "<leader>rmd", "<cmd>RustMoveItemDown<Cr>", k_opts)
    keymap("n", "<leader>rmu", "<cmd>RustMoveItemUp<Cr>", k_opts)
    keymap("n", "<leader>rsb", "<cmd>RustStartStandaloneServerForBuffer<Cr>", k_opts)
    keymap("n", "<leader>rd", "<cmd>RustDebuggables<Cr>", k_opts)
    keymap("n", "<leader>rv", "<cmd>RustViewCrateGraph<Cr>", k_opts)
    keymap("n", "<leader>rw", "<cmd>RustReloadWorkspace<Cr>", k_opts)
    keymap("n", "<leader>rss", "<cmd>RustSSR<Cr>", k_opts)
    keymap("n", "<leader>rxd", "<cmd>RustOpenExternalDocs<Cr>", k_opts)

    require("rust-tools").setup {
      tools = {
        on_initialized = function()
          vim.cmd [[
            autocmd BufEnter,CursorHold,InsertLeave,BufWritePost *.rs silent! lua vim.lsp.codelens.refresh()
          ]]
        end,
      },
      server = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
        settings = {
          ["rust-analyzer"] = {
            lens = {
              enable = true,
              ["references.adt.enable"] = true,
              ["references.trait.enable"] = true,
              ["references.method.enable"] = true,
            },
            inlayHints = {
              enable = true,
              ["typeHints.enable"] = true,
              ["chainingHints.enable"] = true,
              ["reborrowHints.enable"] = true,
              ["parameterHints.enable"] = true,
            },
            checkOnSave = {
              command = "clippy",
              extraArgs = { "--", "-W", "clippy::pedantic"},
            },
          },
        },
      },
    }

    goto continue
  end

  lspconfig[server].setup(opts)
  ::continue::
end


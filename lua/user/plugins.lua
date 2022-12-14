local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use { "wbthomason/packer.nvim"} -- Have packer manage itself
  use { "nvim-lua/plenary.nvim"} -- Useful lua functions used by lots of plugins
  use { "windwp/nvim-autopairs"} -- Autopairs, integrates with both cmp and treesitter
  use { "numToStr/Comment.nvim"} -- comment things easier
  use { "kyazdani42/nvim-web-devicons"}
  use { "kyazdani42/nvim-tree.lua"} -- new nerd tree
  use { "akinsho/bufferline.nvim"} -- buffers are tabs now
  use { "moll/vim-bbye"} -- delete buffers
  use { "nvim-lualine/lualine.nvim"} -- better powerline
  use { "akinsho/toggleterm.nvim"} -- quick access to terminal
  use { "ahmedkhalf/project.nvim"} -- add project support
  use { "lewis6991/impatient.nvim"} -- faster load times
  use { "lukas-reineke/indent-blankline.nvim"} -- add indent guides to all lines
  use { "goolord/alpha-nvim"} -- adds a greeter

  -- Colorschemes
  use { "morhetz/gruvbox" } -- best color scheme

  -- cmp plugins
  use { "hrsh7th/nvim-cmp"} -- The completion plugin
  use { "hrsh7th/cmp-buffer"} -- buffer completions
  use { "hrsh7th/cmp-path"} -- path completions
  use { "saadparwaiz1/cmp_luasnip"} -- snippet completions
  use { "hrsh7th/cmp-nvim-lsp"} -- add lsp support
  use { "hrsh7th/cmp-nvim-lua"}

  -- snippets
  use { "L3MON4D3/LuaSnip"} --snippet engine
  use { "rafamadriz/friendly-snippets"} -- a bunch of snippets to use

  -- LSP
  use { "neovim/nvim-lspconfig"} -- enable LSP
  use { "williamboman/nvim-lsp-installer"} -- simple to use language server installer
  use { "jose-elias-alvarez/null-ls.nvim"} -- for formatters and linters
  use { "RRethy/vim-illuminate"} -- highlight things i'm on
  use { "simrat39/rust-tools.nvim" } -- rust support
  use { "MunifTanjim/eslint.nvim" }

  -- Telescope
  use { "nvim-telescope/telescope.nvim"} -- fuzzy finder

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter" } -- better syntax highlighting

  -- Git
  use { "lewis6991/gitsigns.nvim"} -- show git changes by numbers

  -- DAP
  use { "mfussenegger/nvim-dap"}
  use { "rcarriga/nvim-dap-ui"}
  use { "ravenxrz/DAPInstall.nvim"}

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

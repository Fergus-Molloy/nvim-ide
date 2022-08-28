local colorscheme = "gruvbox"

vim.opt.background = "dark"
vim.cmd [[ set t_Co=256 ]]
vim.cmd [[ let gruvbox_italics=1 ]]
vim.cmd [[ let g:gruvbox_contrast_dark="medium" ]]

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  return
end


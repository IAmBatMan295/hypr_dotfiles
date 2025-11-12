-- ~/.config/nvim/init.lua
-- === 1. Core Clipboard Configuration (Wayland) ===
vim.keymap.set("v", "<Backspace>", '"_d', {
	noremap = true,
	silent = true,
})

vim.keymap.set("v", "<Delete>", '"_d', {
	noremap = true,
	silent = true,
})

vim.opt.number = true -- This enables line numbers
vim.g.clipboard = {
  name = 'Wayland Clipboard',
  copy = {
    ['+'] = 'wl-copy',
    ['*'] = 'wl-copy',
  },
  paste = {
    ['+'] = 'wl-paste --no-newline',
    ['*'] = 'wl-paste --no-newline',
  },
  cache_enabled = 1,
}
vim.opt.clipboard = 'unnamedplus'
-- === End of Clipboard Configuration ===


-- === 2. Install lazy.nvim (Plugin Manager) ===
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
-- THIS LINE IS NOW CORRECTED:
vim.opt.rtp:prepend(lazypath)
-- === End of lazy.nvim Install ===


-- === 3. Configure lazy.nvim AND Load Plugins ===
require("lazy").setup({
  -- The 'spec' table is where we define plugins.
  spec = {
    
    -- We are explicitly defining your colorscheme RIGHT HERE.
    {
      "bjarneo/ash.nvim",
      name = "ash",
      lazy = false,     -- Load this on startup
      priority = 1000,  -- Make sure it loads before anything else
      config = function()
        -- This will run AFTER it's installed
        vim.cmd.colorscheme "ash"
      end,
    },

    -- You can add all future plugins here

  },
})

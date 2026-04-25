-- Disable inlay hints by default (same as <leader>uh toggle)
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
    },
  },
}

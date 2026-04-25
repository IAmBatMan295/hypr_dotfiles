return {
  -- Disable noice LSP signature/hover if using noice
  {
    "folke/noice.nvim",
    optional = true,
    opts = {
      lsp = {
        signature = { enabled = false },
        hover = { enabled = false },
      },
    },
  },

  -- Disable LSP signature help globally
  {
    "neovim/nvim-lspconfig",
    opts = function()
      vim.lsp.handlers["textDocument/signatureHelp"] = function() end
    end,
  },
}

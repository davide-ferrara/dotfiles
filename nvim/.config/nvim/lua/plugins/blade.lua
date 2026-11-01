return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "blade", "html", "php", "javascript", "css" } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "blade-formatter" } },
  },
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { blade = { "blade-formatter" } } },
  },
}

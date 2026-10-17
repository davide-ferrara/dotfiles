-- Small Neovim setup for Python, using Neovim's built-in package manager.
-- Requires Neovim 0.12+ and the existing Mason Pyright install.

-- Neovim 0.12's built-in package manager; no external plugin manager required.
vim.pack.add({
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/folke/noice.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/folke/snacks.nvim",
})

vim.g.mapleader = " "
vim.cmd("filetype plugin indent on")

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars:append({ eob = " " })
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4

-- Use the system clipboard without slowing startup.
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })

vim.diagnostic.config({
  update_in_insert = true,
  severity_sort = true,
  virtual_text = { spacing = 2, source = "if_many" },
  float = { border = "rounded", source = "if_many" },
  signs = true,
  underline = true,
})

local pyright = vim.fn.expand("~/.local/share/nvim/mason/packages/pyright/node_modules/pyright/langserver.index.js")
local node = vim.fn.exepath("node")

local root_markers = {
  "pyrightconfig.json",
  "pyproject.toml",
  "setup.cfg",
  "setup.py",
  "requirements.txt",
  "Pipfile",
  "uv.lock",
  "poetry.lock",
  ".git",
}

vim.lsp.config("pyright", {
  cmd = { node, pyright, "--stdio" },
  filetypes = { "python" },
  root_dir = function(bufnr, on_dir)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(bufnr, root_markers) or vim.fs.dirname(filename)
    on_dir(root)
  end,
  settings = {
    pyright = {
      disableTaggedHints = true,
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        typeCheckingMode = "basic",
        diagnosticMode = "openFilesOnly",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
      },
    },
  },
  flags = { debounce_text_changes = 100 },
})
vim.lsp.enable("pyright")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function(event)
    vim.bo[event.buf].expandtab = true
    vim.bo[event.buf].shiftwidth = 4
    vim.bo[event.buf].softtabstop = 4
    vim.bo[event.buf].tabstop = 4
  end,
})

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Python: hover" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Python: go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Python: references" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

vim.api.nvim_create_user_command("LspStatus", function()
  vim.print(vim.lsp.get_clients({ bufnr = 0 }))
end, { desc = "Show LSP clients attached to this buffer" })

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })

local omarchy_theme = require("omarchy-theme")
omarchy_theme.setup()

require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
    untracked = { text = "+" },
  },
})

local function setup_lualine()
  require("lualine").setup({
    options = {
      theme = omarchy_theme.lualine_theme(),
      globalstatus = true,
      icons_enabled = false,
      component_separators = { left = "│", right = "│" },
      section_separators = { left = "", right = "" },
      refresh = { statusline = 1000 },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        { "branch", fmt = function(branch) return branch ~= "" and ("git:" .. branch) or "" end },
        { "diff", symbols = { added = "+", modified = "~", removed = "-" } },
      },
      lualine_c = {
        { "filename", path = 1, symbols = { modified = " [+]", readonly = " [RO]" } },
      },
      lualine_x = {
        { "diagnostics", sections = { "error", "warn" }, symbols = { error = "E:", warn = "W:" } },
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location", function() return os.date("%H:%M") end },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
  })
end

setup_lualine()
vim.api.nvim_create_autocmd("User", {
  pattern = "OmarchyThemeChanged",
  callback = setup_lualine,
  desc = "Refresh Lualine colors after an Omarchy theme change",
})

require("noice").setup({
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
    format = {
      cmdline = { pattern = "^:", icon = ">", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = "/", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = "?", lang = "regex" },
    },
  },
  views = {
    cmdline_popup = {
      position = { row = 2, col = "50%" },
      size = { width = 60, height = "auto" },
      border = { style = "rounded", padding = { 0, 1 } },
      win_options = {
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
      },
    },
  },
  presets = {
    command_palette = true,
    bottom_search = false,
  },
})

require("nvim-web-devicons").setup({ default = true })
require("snacks").setup({
  explorer = {
    enabled = true,
    replace_netrw = false,
    trash = true,
  },
  picker = {
    enabled = true,
    sources = {
      explorer = {
        focus = "list",
        layout = { hidden = { "input" } },
      },
    },
  },
})

vim.keymap.set("n", "<leader>e", function()
  local root = vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
  Snacks.explorer({ cwd = root })
end, { desc = "Open file explorer" })

vim.keymap.set("n", "<leader><space>", function()
  local root = vim.fs.root(0, { ".git" }) or vim.fn.getcwd()
  Snacks.picker.files({ cwd = root })
end, { desc = "Find files" })

local M = {}

local palette_path = vim.fn.expand("~/.local/state/omarchy/current/theme/colors.toml")
local theme_name_path = vim.fn.expand("~/.local/state/omarchy/current/theme.name")
local watcher

local function read_palette()
  local file = io.open(palette_path, "r")
  if not file then
    return nil
  end

  local palette = {}
  for line in file:lines() do
    local key, value = line:match('^%s*([%w_]+)%s*=%s*"([^\"]+)"')
    if key then
      palette[key] = value
    end
  end
  file:close()
  return palette
end

local function set(name, attrs)
  vim.api.nvim_set_hl(0, name, attrs)
end

local function apply()
  local p = read_palette()
  if not p or not p.background or not p.foreground then
    return
  end

  vim.o.termguicolors = true
  vim.o.background = p.mode == "light" and "light" or "dark"

  local bg = p.background
  local fg = p.foreground
  local muted = p.muted or p.dark_foreground or fg
  local accent = p.accent or p.blue or fg
  local selection = p.selection or p.lighter_background or bg
  local selection_fg = p.selection_foreground or fg

  -- Keep Omarchy's terminal background visible, like the previous setup.
  for _, group in ipairs({ "Normal", "NormalNC", "NormalFloat", "FloatBorder", "SignColumn", "EndOfBuffer", "FoldColumn" }) do
    set(group, { fg = fg, bg = "NONE" })
  end
  set("LineNr", { fg = muted, bg = "NONE" })
  set("CursorLineNr", { fg = accent, bg = "NONE", bold = true })
  set("Comment", { fg = muted, italic = true })
  set("Constant", { fg = p.orange or p.yellow or accent })
  set("String", { fg = p.green or fg })
  set("Character", { fg = p.green or fg })
  set("Number", { fg = p.orange or p.yellow or accent })
  set("Boolean", { fg = p.red or accent, bold = true })
  set("Identifier", { fg = fg })
  set("Function", { fg = p.blue or accent })
  set("Statement", { fg = p.magenta or accent })
  set("Keyword", { fg = p.magenta or accent })
  set("Type", { fg = p.yellow or accent })
  set("Special", { fg = p.cyan or accent })
  set("PreProc", { fg = p.orange or accent })
  set("Operator", { fg = p.cyan or fg })
  set("Visual", { fg = selection_fg, bg = selection })
  set("Search", { fg = bg, bg = p.yellow or accent, bold = true })
  set("IncSearch", { fg = bg, bg = accent, bold = true })
  set("Pmenu", { fg = fg, bg = p.lighter_background or bg })
  set("PmenuSel", { fg = selection_fg, bg = selection, bold = true })
  set("StatusLine", { fg = fg, bg = "NONE" })
  set("StatusLineNC", { fg = muted, bg = "NONE" })
  set("DiagnosticError", { fg = p.red or accent })
  set("DiagnosticWarn", { fg = p.yellow or accent })
  set("DiagnosticInfo", { fg = p.cyan or accent })
  set("DiagnosticHint", { fg = muted })
  set("DiffAdd", { fg = p.green or fg, bg = "NONE" })
  set("DiffChange", { fg = p.yellow or fg, bg = "NONE" })
  set("DiffDelete", { fg = p.red or fg, bg = "NONE" })

  -- Treesitter captures use the same Omarchy palette without a theme plugin.
  set("@comment", { link = "Comment" })
  set("@string", { link = "String" })
  set("@number", { link = "Number" })
  set("@boolean", { link = "Boolean" })
  set("@function", { link = "Function" })
  set("@keyword", { link = "Keyword" })
  set("@type", { link = "Type" })
  set("@operator", { link = "Operator" })
end

function M.setup()
  apply()

  vim.api.nvim_create_autocmd("FocusGained", {
    desc = "Refresh Omarchy palette when Neovim regains focus",
    callback = apply,
  })

  watcher = vim.uv.new_fs_event()
  if watcher then
    watcher:start(theme_name_path, {}, function(err)
      if not err then
        vim.defer_fn(function()
          vim.schedule(apply)
        end, 150)
      end
    end)
  end
end

return M

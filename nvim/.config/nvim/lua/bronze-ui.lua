local M = {}
local art = require("bronze-art")

function M.apply()
  local light = vim.o.background == "light"
  local gold = light and "#845322" or "#E2B779"
  local copper = light and "#945E40" or "#C58B66"
  local patina = light and "#366B63" or "#8DB6A5"
  local muted = light and "#847363" or "#8E8075"
  local cream = light and "#493C31" or "#E8DDCA"
  local shades = light and {"#BDAD97", "#AB9578", "#98805E", "#866B49", "#735635", "#614326", "#51351B", "#402912", "#30200E"}
    or {"#655047", "#7B5B48", "#92694D", "#AA7B55", "#BF9161", "#D1A671", "#DFBE8B", "#ECD2A3", "#F6E7C8"}
  local function set(name, attrs) vim.api.nvim_set_hl(0, name, attrs) end
  for i, color in ipairs(shades) do set("BronzeArt" .. i, { fg = color }) end
  set("BronzeTitle", { fg = gold, bold = true })
  set("BronzeMuted", { fg = muted })
  set("BronzePatina", { fg = patina })
  set("BronzeRule", { fg = copper })
  for _, name in ipairs({ "SnacksDashboardKey", "SnacksDashboardIcon", "SnacksDashboardTitle", "SnacksPickerPrompt", "SnacksPickerBorder", "FloatBorder", "WhichKey", "CursorLineNr" }) do
    set(name, { fg = gold, bold = true })
  end
  set("SnacksDashboardDesc", { fg = cream })
  set("SnacksDashboardFile", { fg = cream })
  set("SnacksDashboardDir", { fg = muted })
  set("SnacksDashboardFooter", { fg = patina })
  set("SnacksPickerDirectory", { fg = patina })
  set("SnacksPickerMatch", { fg = gold, bold = true })
  set("SnacksPickerTitle", { fg = light and "#FFF8ED" or "#24201E", bg = copper, bold = true })
end

function M.setup()
  M.apply()
  local group = vim.api.nvim_create_augroup("BronzeUI", { clear = true })
  vim.api.nvim_create_autocmd({ "ColorScheme", "FocusGained" }, { group = group, callback = M.apply })
  vim.api.nvim_create_autocmd("User", { group = group, pattern = "OmarchyThemeChanged", callback = M.apply })
end

function M.lualine_theme()
  return require("omarchy-theme").lualine_theme()
end

local function colored_art(text)
  local chunks = {}
  local ramp = ".:-=+*#%@"
  for char in text:gmatch(".") do
    local level = ramp:find(char, 1, true)
    local hl = level and ("BronzeArt" .. level) or "BronzeMuted"
    local previous = chunks[#chunks]
    if previous and previous.hl == hl then
      previous[1] = previous[1] .. char
    else
      chunks[#chunks + 1] = { char, hl = hl }
    end
  end
  return chunks
end

function M.sections(dashboard)
  local size = dashboard:size()
  local width = math.max(1, math.min(64, size.width - 4))
  dashboard.opts.width = width
  local recent = size.height >= 48 and width >= 36
  local available = size.height - (recent and 22 or 17)
  local selected
  for _, candidate in ipairs(art) do
    if candidate.width <= width and candidate.height <= available then
      selected = candidate
      break
    end
  end
  local function centered(text, hl, padding)
    return { text = { { text, hl = hl } }, align = "center", padding = padding }
  end
  local items = {
    centered("◈  Bronze Nvim  ◈", "BronzeTitle", 1),
  }
  if selected then
    items[#items + 1] = { text = colored_art(selected.text), align = "center" }
    items[#items + 1] = centered("RIACE  ·  5TH CENTURY BC", "BronzeMuted", 1)
  end
  items[#items + 1] = centered(string.rep("─", math.max(1, width - 8)), "BronzeRule")
  items[#items + 1] = { section = "keys", gap = 0, padding = 1 }
  if recent then
    items[#items + 1] = { section = "recent_files", limit = 3, title = "Recent files", icon = " " , padding = 1 }
  end
  items[#items + 1] = centered("by Davide Ferrara", "BronzeMuted")
  return items
end

return M

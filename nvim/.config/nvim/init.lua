vim.filetype.add({ pattern = { [".*%.blade%.php"] = "blade" } })

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

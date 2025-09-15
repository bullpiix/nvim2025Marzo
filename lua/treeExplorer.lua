
-- Cargar fzf-lua
local fzf = require("fzf-lua")

fzf.setup({
  winopts = {
    height = 0.85,
    width = 0.80,
    preview = {
      layout = "vertical", -- vista previa vertical
    },
  },
})

-- Atajos de teclado
vim.keymap.set("n", "gy", fzf.files, { desc = "Buscar archivos" })
vim.keymap.set("n", "gu", fzf.live_grep, { desc = "Grep en proyecto" })
vim.keymap.set("n", "gi", fzf.buffers, { desc = "Buffers abiertos" })
vim.keymap.set("n", "gh", fzf.oldfiles, { desc = "Archivos recientes" })
vim.keymap.set("n", "gj", function()
  require("fzf-lua").files({ cwd = "~" })
end, { desc = "Buscar archivos desde HOME" })
vim.keymap.set("n", "gk", function()
  require("fzf-lua").live_grep({ cwd = "~" })
end, { desc = "Grep desde HOME" })


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
vim.keymap.set("n", "gu", fzf.live_grep, { desc = "Grep en proyecto" })
vim.keymap.set("n", "gi", fzf.buffers, { desc = "Buffers abiertos" })
vim.keymap.set("n", "gh", fzf.oldfiles, { desc = "Archivos recientes" })
vim.keymap.set("n", "gj", function()
  require("fzf-lua").files({ cwd = "~" })
end, { desc = "Buscar archivos desde HOME" })
vim.keymap.set("n", "gk", function()
  require("fzf-lua").live_grep({ cwd = "~" })
end, { desc = "Grep desde HOME" })

vim.keymap.set("n", "gy", function()
  require("fzf-lua").files({
    cwd = vim.fn.expand("%:p:h"), -- carpeta del buffer actual
  })
end, { desc = "Buscar archivos en carpeta del buffer" })

vim.keymap.set("n", "gL", function()
  require("fzf-lua").live_grep({
    cwd = vim.fn.expand("%:p:h"), -- carpeta del buffer actual
  })
end, { desc = "Grep en carpeta del buffer" })


function sql_consulta()
    vim.cmd("vsplit")  -- Split vertical
    vim.cmd("terminal")  -- Abrir terminal
    vim.fn.chansend(vim.b.terminal_job_id, "cd /home/manutip/Documents/blender/sql-server-samples/samples/databases/northwind-pubs && sqlcmd -S localhost,1433 -U SA -P 'TuPassword123!' -C -i bufer.sql\n")
end

function bufer_master()
  local base = "/home/manutip/Documents/blender/sql-server-samples/samples/databases/northwind-pubs"

  -- Guardar selección en bufer_tres.sql
  vim.cmd("silent! '<,'>w! " .. base .. "/bufer_tres.sql")

  -- Sobrescribir bufer.sql con bufer_dos.sql
  vim.fn.system({ "cp", base .. "/bufer_two.sql", base .. "/bufer.sql" })

  -- Agregar contenido de bufer_tres.sql al final de bufer.sql
  vim.fn.system({ "sh", "-c", "cat " .. base .. "/bufer_tres.sql >> " .. base .. "/bufer.sql" })
  print("manuel")
end

vim.keymap.set("v", "tl", ':lua bufer_master()<CR>:lua sql_consulta()<CR>',{ noremap = true, silent = true })

vim.keymap.set("v", "to", ":w! /home/manutip/Documents/blender/sql-server-samples/samples/databases/northwind-pubs/bufer_two.sql<CR>", { desc = "Guardado fijo" })
vim.keymap.set("v", "tp", ":w! /home/manutip/Documents/blender/sql-server-samples/samples/databases/northwind-pubs/bufer.sql<CR>:lua sql_consulta()<CR>", { desc = "Guardado fijo" })


--vim.keymap.set("v", "tl", ":w >> /home/manutip/Documents/blender/sql-server-samples/samples/databases/northwind-pubs/bufer.sql<CR>:lua sql_consulta()<CR>", { desc = "Guardado dinamico" })






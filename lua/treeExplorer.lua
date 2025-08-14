require('telescope').setup{}

vim.keymap.set('n', '<Space>m', ':Telescope find_files<CR>', { noremap = true })
vim.keymap.set('n', '<Space>,', ':Telescope live_grep<CR>', { noremap = true })
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--configuracion para neo tree
--
function BuscarLineaConMenorIndentacion()
    local fila_actual = vim.fn.line(".")
    local indent_actual = vim.fn.indent(fila_actual)
    for i = fila_actual - 1, 1, -1 do
    local indent_i = vim.fn.indent(i)
    if indent_i < indent_actual then
      vim.api.nvim_win_set_cursor(0, {i, 0})
      return
    end
    end
    print("No se encontró línea con menor indentación")
end

vim.keymap.set('n', '0', "ma:lua BuscarLineaConMenorIndentacion()<CR>", { noremap = true, silent = true })

function BuscarLineaConIndentacionAvanzado()
  local fila_actual = vim.fn.line(".")
  local indent_actual = vim.fn.indent(fila_actual)
  local fila_menor = nil
  -- Buscar la primera línea hacia arriba con menor indentación
  for i = fila_actual - 1, 1, -1 do
    local indent_i = vim.fn.indent(i)
    if indent_i < indent_actual then
      fila_menor = i
      break
    end
  end
  if not fila_menor then
    print("No se encontró línea con menor indentación")
    return
  end
  for i = fila_menor - 1, 1, -1 do
    local indent_i = vim.fn.indent(i)
    if indent_i >= indent_actual then
      vim.api.nvim_win_set_cursor(0, {i, 0})
      return
    end
  end

  -- Si no se encuentra ninguna, moverse a la línea con menor indentación encontrada
  vim.api.nvim_win_set_cursor(0, {fila_menor, 0})
end

function get_posicion()
    print("posicion guardada")
end
vim.keymap.set('n', '9', ":lua BuscarLineaConIndentacionAvanzado()<CR>zc", { noremap = true, silent = true })
vim.keymap.set('n', '<Tab>w', "ma:lua get_posicion()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<Tab>e', "`a", { noremap = true, silent = true })











vim.o.foldmethod = "indent"









vim.api.nvim_set_hl(0, "Folded", { fg = "#a83250", bg = "#a83250", italic = true })
vim.opt.wrap = false
vim.g.loaded_matchparen = 1
local indent_cache = ""
function CaptureIndent()
  local line = vim.api.nvim_get_current_line()
  indent_cache = line:match("^%s*") or ""
  print("Indentation captured")
end

-- Aplica la indentación capturada a la línea actual
function ApplyIndent()
  local line = vim.api.nvim_get_current_line()
  local new_line = indent_cache .. line:gsub("^%s*", "")
  vim.api.nvim_set_current_line(new_line)
  print("Indentation applied")
end

vim.api.nvim_set_keymap('v', 'q', 'ma"+y<CR>`a', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'q', 'ma^v$"+y:lua CaptureIndent()<CR>`a', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'w', 'ma$i<Right><CR><Esc>"+p:lua ApplyIndent()<CR>`a', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Tab>', 'ma"+p<CR>`a', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>i', 'viw', { noremap = true, silent = true })


vim.opt.expandtab = true          -- Convertir las pestañas en espacios
vim.opt.shiftwidth = 4            -- El tamaño de la indentación
vim.opt.softtabstop = 4           -- Tabulación suave (en modo de inserción)
vim.opt.tabstop = 4               -- El tamaño real de un tabulador


vim.opt.fillchars = "fold: "
vim.opt.foldtext = "getline(v:foldstart)"
-- Mapeos en modo visual para mover las líneas seleccionadas
vim.api.nvim_set_keymap('n', 't', ':tabnew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>q', 'v', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>w', 'V', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>1', ':tabnext<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'r', ':q!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 's', ':w!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'd', 'u', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'a', '<C-r>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'e', 'dd', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'e', '<Del>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'c', 'zc', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n',';', 'a', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i',';', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v',';', '<Esc>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('i',"<Tab>'", '<Right><Esc>:lua CaptureIndent()<CR>i<CR><Esc>:lua ApplyIndent()<CR><Up>o', { noremap = true, silent = true })


vim.api.nvim_set_keymap('n',"'", '$a<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i',"'", '<BackSpace>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v',"'", '<Del>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','o', 'b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','p', 'e', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v','p', 'e', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v','o', 'b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','ip', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','io', '0', { noremap = true, silent = true })

vim.api.nvim_set_keymap('v','ip', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v','io', '^', { noremap = true, silent = true })

vim.api.nvim_set_keymap('i','<Tab>d', '=', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>s', '.', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>a', ':', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>q', ',', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>w', ';', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>e', '_', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>z', '-', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>x', '/', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>c', '<', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>f', '>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('i','<Tab>p', '()<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>o', '{}<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>i', '[]<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>l', '""<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>k', "''<Left>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>j', '+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>n', '*', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>m', '!', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>b', '#', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i','<Tab>h', '%', { noremap = true, silent= true })
vim.api.nvim_set_keymap('i','<Tab>y', '\\', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Space>d', ':vsplit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '1', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '2', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>l', 'ggVG', { noremap = true, silent = true })



vim.keymap.set("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.keymap.set("v", "<Space>", "<gv", { noremap = true, silent = true })


function  encerrar_etiquera()
  -- Copia la palabra bajo el cursor
  vim.cmd('normal! yiw')
  local word = vim.fn.getreg('"')

  -- Reemplaza la palabra por <word></word>
  vim.cmd('normal! ciw<' .. word .. '></' .. word .. '>')

  -- Mueve el cursor al medio de las etiquetas y entra en modo insertar
  vim.cmd('normal! F>i')
end
vim.api.nvim_set_keymap('n', '<Space>o', ':lua encerrar_etiquera()<CR><Right><Right>i', { noremap = true, silent = true })


function  simple_etiquera()
  -- Copia la palabra bajo el cursor
  vim.cmd('normal! yiw')
  local word = vim.fn.getreg('"')
  -- Copia la palabra bajo el cursor
  -- Reemplaza la palabra por <word></word>
  vim.cmd('normal! ciw<' .. word .. '>')
end
vim.api.nvim_set_keymap('n', '<Space>p', ':lua simple_etiquera()<CR><Left>i', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Space>y', 'G', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>t', 'gg', { noremap = true, silent = true })


function my_grap()
  vim.schedule(function()
    -- Pedimos al usuario la etiqueta
    vim.ui.input({ prompt = "Nombre de la etiqueta: " }, function(tag)
      if not tag or tag == "" then return end -- Cancelado o vacío

      local start = vim.fn.line("'<")
      local end_ = vim.fn.line("'>")

      -- Obtener la primera línea del buffer
      local line = vim.api.nvim_buf_get_lines(0, start - 1, start, false)[1]
      local indent = line:match("^(%s*)") or ""

      -- Insertar etiquetas con identación
      vim.api.nvim_buf_set_lines(0, end_, end_, false, { indent .. "</" .. tag .. ">" })
      vim.api.nvim_buf_set_lines(0, start - 1, start - 1, false, { indent .. "<" .. tag .. ">" })

      -- Aplicar indentación extra a las líneas seleccionadas
      local extra_indent = "    " -- ← Cuatro espacios
      for i = start, end_ do
        local current = vim.api.nvim_buf_get_lines(0, i, i + 1, false)[1]
        vim.api.nvim_buf_set_lines(0, i, i + 1, false, { extra_indent .. current })
      end
    end)
  end)
end

vim.api.nvim_set_keymap('v', '9', ':lua my_grap()<CR>', { noremap = true, silent = true })

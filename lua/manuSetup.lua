
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

vim.opt.expandtab = true          -- Convertir las pestañas en espacios
vim.opt.shiftwidth = 4            -- El tamaño de la indentación
vim.opt.softtabstop = 4           -- Tabulación suave (en modo de inserción)
vim.opt.tabstop = 4               -- El tamaño real de un tabulador


vim.opt.fillchars = "fold: "
vim.opt.foldtext = "getline(v:foldstart)"
-- Mapeos en modo visual para mover las líneas seleccionadas
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '|', '<gv', { noremap = true, silent = true })
-- Mapeos para Modos 
vim.api.nvim_set_keymap('n', 't', ':tabnew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>q', 'v', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>w', 'V', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>3', ':tabnext<CR>', { noremap = true, silent = true })

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

vim.api.nvim_set_keymap('n',"'", '$a<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i',"'", '<BackSpace>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v',"'", '<Del>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','o', 'b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','p', 'e', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v','p', 'e', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v','o', 'b', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','ip', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','io', '^', { noremap = true, silent = true })

vim.api.nvim_set_keymap('v','ip', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v','io', '^', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n','md', 'a=', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','ms', 'a.', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','ma', 'a:', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','mq', 'a,', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','mw', 'a;', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','me', 'a_', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','mz', 'a-', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','mx', 'a/', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','mc', 'a<', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','mf', 'a>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n','iq', 'a()<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','iw', 'a{}<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','ie', 'a[]<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','ia', 'a""<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','is', "a''<Left>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','id', 'a+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','iz', 'a*', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','ix', 'a!', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','ic', 'a#', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','if', 'a%', { noremap = true, silent= true })
vim.api.nvim_set_keymap('n','il', 'a\\', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Space>d', ':vsplit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '1', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '2', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Space>l', 'ggVG', { noremap = true, silent = true })

vim.opt.guicursor = "n-v-c-i:block,r-cr-o:block"

vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
 
vim.opt.wrap = false
vim.g.loaded_matchparen = 1
vim.api.nvim_set_keymap('n', 'h', ':Ex<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'q', 'ma"+y<CR>`a', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'q', 'ma^v$"+y:lua CaptureIndent()<CR>`a', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'w', 'ma$i<Right><CR><Esc>"+p:lua ApplyIndent()<CR>`a', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ñ', 'ggVG', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Tab>', 'ma"+p<CR>`a', { noremap = true, silent = true })

-- Configuración para que el comportamiento de las pestañas sea consistent
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
vim.api.nvim_set_keymap('n', 'r', ':q!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 's', ':w!<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'd', 'u', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'a', '<C-r>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'e', 'dd', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v','<BackSpace>', '<Del>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','<M-e>', '/', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','<Esc>', 'i', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n','1', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n','2', '$', { noremap = true, silent = true })
vim.opt.shiftwidth = 4            -- El tamaño de la indentación
vim.api.nvim_set_keymap('v','1', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v','2', '$', { noremap = true, silent = true })

local indent_cache = ""

-- Captura la indentación de la línea actual
vim.api.nvim_set_keymap("n", "z", [[:lua CaptureIndent()<CR>]], { noremap = true, silent = true })
function CaptureIndent()
  local line = vim.api.nvim_get_current_line()
  indent_cache = line:match("^%s*") or ""
  print("Indentation captured")
end

-- Aplica la indentación capturada a la línea actual
vim.api.nvim_set_keymap("n", "x", [[:lua ApplyIndent()<CR>]], { noremap = true, silent = true })
function ApplyIndent()
  local line = vim.api.nvim_get_current_line()
  local new_line = indent_cache .. line:gsub("^%s*", "")
  vim.api.nvim_set_current_line(new_line)
  print("Indentation applied")
end

vim.api.nvim_set_keymap('n', 'k', 'zM', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'l', 'zR', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '|', 'zc', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', 'o', 'aw', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '}', 'gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '{', '*', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<', 'viw', { noremap = true, silent = true })


vim.g.nvim_set_keymap = ""

vim.api.nvim_set_keymap('v', 'Q', '"+y<ESC><Cmd>lua vim.g.xbuscar = vim.fn.getreg("+")<CR><Cmd>lua CopiarPalabra()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', 'W', ':lua vim.fn.setreg("/", vim.g.xbuscar)<CR>n', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'S', [[:normal! cgn<C-r>+<Esc>]], { noremap = true, silent = true })


function CopiarPalabra()
    local clipboard = vim.fn.getreg("+")  -- Obtener el contenido actual del portapapeles
    local palabra = vim.fn.input("palabra a remplazar : ", clipboard)
    if palabra ~= "" then
        vim.fn.setreg("+", palabra)  -- Copia al portapapeles del sistema
    else
        print("No ingresaste ninguna palabra.")
    end
end


function SetPromp()
    local json_path = "/home/manutip/Documents/iaPro/dataIa.json"
    local clipboard = vim.fn.getreg("+")  -- Obtener el contenido actual del portapapeles
    local palabra = vim.fn.input("concepto basico de : ", clipboard)
    if palabra == "" then
        print("No ingresaste ninguna palabra.")
        return
    end

    local file = io.open(json_path, "r")
    local content = file and file:read("*a") or "{}"
    if file then file:close() end

    local ok, data = pcall(vim.fn.json_decode, content)
    if not ok then
        print("Error al leer el archivo JSON.")
        return
    end

    data["mode"] = palabra
    data["promp"] = 1

    file = io.open(json_path, "w")
    if not file then
        print("Error al escribir en el archivo JSON.")
        return
    end
    file:write(vim.fn.json_encode(data))

    file:close()

    vim.cmd("vsplit")  -- Split vertical
    vim.cmd("terminal")  -- Abrir terminal
    vim.fn.chansend(vim.b.terminal_job_id, "cd /home/manutip/Documents/iaPro && ./venv/bin/python openia.py\n")

end
-- Mapear la tecla W en modo normal
vim.api.nvim_set_keymap('v', 'Z', '"+y<ESC><Cmd>lua vim.g.xbuscar = vim.fn.getreg("+")<CR>:lua SetPromp()<CR>', { noremap = true, silent = true })


function PrompAbrebiatura()
    local json_path = "/home/manutip/Documents/iaPro/dataIa.json"
    local clipboard = vim.fn.getreg("+")  -- Obtener el contenido actual del portapapeles
    local palabra = vim.fn.input("Abrebiatura significado de : ", clipboard)
    if palabra == "" then
        print("No ingresaste ninguna palabra.")
        return
    end

    local file = io.open(json_path, "r")
    local content = file and file:read("*a") or "{}"
    if file then file:close() end

    local ok, data= pcall(vim.fn.json_decode, content)
    if not ok then
        print("Error al leer el archivo JSON.")
        return
    end

    data["mode"] = palabra
    data["promp"] = 0 

    file = io.open(json_path, "w")
    if not file then
        print("Error al escribir en el archivo JSON.")
        return
    end
    file:write(vim.fn.json_encode(data))
    file:close()

    vim.cmd("vsplit")  -- Split vertical
    vim.cmd("terminal")  -- Abrir terminal
    vim.fn.chansend(vim.b.terminal_job_id, "cd /home/manutip/Documents/iaPro && ./venv/bin/python openia.py\n")

end
-- Mapear la tecla W en modo normal
vim.api.nvim_set_keymap('v', 'X', '"+y<ESC><Cmd>lua vim.g.xbuscar = vim.fn.getreg("+")<CR>:lua PrompAbrebiatura()<CR>', { noremap = true, silent = true })

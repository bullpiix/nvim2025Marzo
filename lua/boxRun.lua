
local current_page = 1
local page_size = 5
local win_id, buf_id
local current_filepath = nil
local file_dir = nil

-- Opciones disponibles y funciones asociadas
local options = {
    {
        label = "Copiar ruta completa del archivo",
		action = function()
		    if current_filepath then
			vim.fn.setreg("+", current_filepath) -- Copiar al portapapeles (registro +)
			print("Ruta copiada al portapapeles: " .. current_filepath)
		    else
			print("No se encontró la ruta del archivo.")
		    end
		end,
	    },

	    { label = "info- box", action = function() _G.show_info_window() end },
	    { label = "current neoTree", action = function() set_neotree() end },
	    { label = "root neoTree", action = function() set_root_neotree() end },
	    { label = "open Carpeta", action = function() open_current_folder() end },
	    { label = "Opción 6", action = function() print("Ejecutando función 6") end },
	    { label = "Opción 7", action = function() print("Ejecutando función 7") end },
	    { label = "Opción 8", action = function() print("Ejecutando función 8") end },
	    { label = "Opción 9", action = function() print("Ejecutando función 9") end },
	    { label = "Opción 10", action = function() print("Ejecutando función 10") end },
	}
	-- Función para ejecutar la opción seleccionada
	function _G.select_option()
	    local selected_line = vim.fn.line(".")
	    local option_idx = (current_page - 1) * page_size + selected_line
	    if options[option_idx] then
		options[option_idx].action()
	    end
	    _G.close_window()
	end

	-- Función para cambiar a la siguiente página
	function _G.next_page()
	    current_page = current_page + 1
	    if current_page > math.ceil(#options / page_size) then
		current_page = 1 -- Volver al inicio
	    end
	    _G.show_selection_window()
	end

	-- Función para cambiar a la página anterior
	function _G.previous_page()
	    current_page = current_page - 1
	    if current_page < 1 then
		current_page = math.ceil(#options / page_size) -- Ir al final
	    end
	    _G.show_selection_window()
	end

	-- Función para cerrar la ventana flotante
	function _G.close_window()
	    if win_id then
		vim.api.nvim_win_close(win_id, true)
		win_id = nil
		buf_id = nil
	    end
	end

	function _G.show_selection_window()
        file_dir = vim.fn.expand("%:p:h")
	    current_filepath = vim.fn.expand("%:p")
	    local total_pages = math.ceil(#options / page_size)

	    -- Calcular elementos de la página actual
	    local start_idx = (current_page - 1) * page_size + 1
	    local end_idx = math.min(start_idx + page_size - 1, #options)
	    local page_options = {}
	    for i = start_idx, end_idx do
		table.insert(page_options, options[i].label)
	    end

	    -- Crear un buffer flotante si no existe
	    if not buf_id or not vim.api.nvim_buf_is_valid(buf_id) then
		buf_id = vim.api.nvim_create_buf(false, true)
	    end

	    -- Crear ventana flotante si no existe
	    if not win_id or not vim.api.nvim_win_is_valid(win_id) then
		local win_opts = {
		    relative = "editor",
		    width = 30,
		    height = #page_options,
		    row = math.floor((vim.o.lines - #page_options) / 2),
		    col = math.floor((vim.o.columns - 30) / 2),
		    style = "minimal",
		    border = "rounded",
		}
		win_id = vim.api.nvim_open_win(buf_id, true, win_opts)
	    end

	    -- Hacer el buffer modificable temporalmente
	    vim.api.nvim_buf_set_option(buf_id, "modifiable", true)

	    -- Actualizar las opciones en el buffer
	    vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, page_options)

	    -- Configurar el buffer como no modificable nuevamente
	    vim.api.nvim_buf_set_option(buf_id, "modifiable", false)

	    -- Configurar teclas para la ventana
	    vim.api.nvim_buf_set_keymap(buf_id, "n", "<CR>", ":lua _G.select_option()<CR>", { noremap = true, silent = true })
	    vim.api.nvim_buf_set_keymap(buf_id, "n", "n", ":lua _G.next_page()<CR>", { noremap = true, silent = true })
	    vim.api.nvim_buf_set_keymap(buf_id, "n", "p", ":lua _G.previous_page()<CR>", { noremap = true, silent = true })
	    vim.api.nvim_buf_set_keymap(buf_id, "n", "q", ":lua _G.close_window()<CR>", { noremap = true, silent = true })
	end
	vim.api.nvim_set_keymap("n", "gv", ":lua _G.show_selection_window()<CR>", { noremap = true, silent = true })

	local info_buf, info_win
	local infopage = 1
	local info_size = 6

	-- Datos informativos
	local shortcuts = {
	    { key = "<Space>+", action = "'Emet'" },
	    { key = ",", action = "autoIdent <div>" },
	    { key = "<tab>d", action = "Escribe '='" },
	    { key = "<tab>s", action = "Escribe '.'" },
	    { key = "<tab>a", action = "Escribe ':'" },
	    { key = "<tab>q", action = "Escribe ','" },
	    { key = "<tab>w", action = "Escribe ';'" },
	    { key = "<tab>e", action = "Escribe '_'" },
	    { key = "<tab>z", action = "Escribe '-'" },
	    { key = "<tab>x", action = "Escribe '/'" },
	    { key = "<tab>c", action = "Escribe '<'" },
	    { key = "<tab>f", action = "Escribe '>'" },
	    { key = "<tab>p", action = "Escribe '()'" },
	    { key = "<tab>o", action = "Escribe '{}'" },
	    { key = "<tab>k", action = "Escribe '' " },
	    { key = "<tab>j", action = "Escribe '+'" },
	    { key = "<tab>n", action = "Escribe '*'" },
	    { key = "<tab>m", action = "Escribe '!'" },
	    { key = "<tab>b", action = "Escribe '#'" },
	    { key = "<tab>h", action = "Escribe '%'" },
	    { key = "<tab>l", action = 'Escribe " ' },
	    { key = "<tab>y", action = "Escribe \\ " },
}

function open_current_folder()
  if vim.fn.has("unix") == 1 then
    os.execute("xdg-open '" .. file_dir  .. "' &")
  else
    print("Solo soportado en sistemas tipo Unix por ahora")
  end
end
function set_root_neotree()
    local root = "~"
    vim.fn.feedkeys(":Neotree " .. root .. "\n", "n")   
end
function set_neotree()
    vim.fn.feedkeys(":Neotree " .. file_dir .. "\n", "n")   
end
function _G.show_info_window()
    -- Crear el buffer si no existe
    if not info_buf or not vim.api.nvim_buf_is_valid(info_buf) then
        info_buf = vim.api.nvim_create_buf(false, true)
    end

    -- Calcular elementos de la página actual
    local total_pages = math.ceil(#shortcuts / info_size)
    local start_idx = (infopage - 1) * info_size + 1
    local end_idx = math.min(start_idx + info_size - 1, #shortcuts)

    local lines = { "Atajos disponibles (Página " .. infopage .. " de " .. total_pages .. "):" }
    for i = start_idx, end_idx do
        local shortcut = shortcuts[i]
        table.insert(lines, string.format("Tecla: %s  →  Acción: %s", shortcut.key, shortcut.action))
    end
    if total_pages > 1 then
        table.insert(lines, "")
    end

    -- Configurar la ventana flotante
    local win_opts = {
        relative = "editor",
        width = 50,
        height = #lines,
        row = math.floor((vim.o.lines - #lines) / 2),
        col = math.floor((vim.o.columns - 50) / 2),
        style = "minimal",
        border = "rounded",
    }

    -- Crear la ventana flotante si no existe
    if not info_win or not vim.api.nvim_win_is_valid(info_win) then
        info_win = vim.api.nvim_open_win(info_buf, true, win_opts)
    end

    -- Hacer el buffer modificable temporalmente
    vim.api.nvim_buf_set_option(info_buf, "modifiable", true)

    -- Escribir los datos en el buffer
    vim.api.nvim_buf_set_lines(info_buf, 0, -1, false, lines)

    -- Configurar el buffer como no modificable nuevamente
    vim.api.nvim_buf_set_option(info_buf, "modifiable", false)

    -- Configurar teclas para la ventana
    vim.api.nvim_buf_set_keymap(info_buf, "n", "q", ":lua _G.close_info_window()<CR>", { noremap = true, silent = true })
    if total_pages > 1 then
        vim.api.nvim_buf_set_keymap(info_buf, "n", "n", ":lua _G.next_info_page()<CR>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(info_buf, "n", "p", ":lua _G.previous_info_page()<CR>", { noremap = true, silent = true })
    end
end

-- Función para avanzar a la siguiente página
function _G.next_info_page()
    local total_pages = math.ceil(#shortcuts / info_size)
    infopage = infopage + 1
    if infopage > total_pages then
        infopage = 1 -- Volver a la primera página
    end
    _G.show_info_window()
end

-- Función para retroceder a la página anterior
function _G.previous_info_page()
    local total_pages = math.ceil(#shortcuts / info_size)
    infopage = infopage - 1
    if infopage < 1 then
        infopage = total_pages -- Ir a la última página
    end
    _G.show_info_window()
end

-- Función para cerrar la ventana flotante
function _G.close_info_window()
    if info_win and vim.api.nvim_win_is_valid(info_win) then
        vim.api.nvim_win_close(info_win, true)
    end
    info_win = nil
    info_buf = nil
    infopage = 1
end





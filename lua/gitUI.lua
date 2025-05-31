

local input_win_id, input_buf_id, btn_win_id, btn_buf_id

local file_dir -- Variable global para almacenar la ruta del archivo

local nameRama
-- Función para capturar la ruta del archivo antes de abrir la ventana
function _G.capture_file_dir()
    file_dir = vim.fn.expand("%:p:h") -- Guardar la ruta antes de abrir la ventana
end
-- Función para crear la entrada de texto
function _G.create_input_window()
    input_buf_id = vim.api.nvim_create_buf(false, true)
    local width, height = 40, 1
    local row, col = math.floor((vim.o.lines - height) / 2), math.floor((vim.o.columns - width) / 2)

    input_win_id = vim.api.nvim_open_win(input_buf_id, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.api.nvim_buf_set_option(input_buf_id, "modifiable", true)
    vim.api.nvim_buf_set_keymap(input_buf_id, "i", "<CR>", "<Esc>:lua _G.focus_confirm_button()<CR>", { noremap = true, silent = true })
end

function _G.focus_confirm_button()
    if btn_win_id and vim.api.nvim_win_is_valid(btn_win_id) then
        vim.api.nvim_set_current_win(btn_win_id) -- Mueve el foco al botón
    end
end
-- Función para crear el botón de confirmación
function _G.create_confirm_button(labelButton)
    btn_buf_id = vim.api.nvim_create_buf(false, true)
    local row, col = math.floor((vim.o.lines - 1) / 2) + 2, math.floor((vim.o.columns - 20) / 2)

    btn_win_id = vim.api.nvim_open_win(btn_buf_id, true, {
        relative = "editor",
        width = 20,
        height = 1,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.api.nvim_buf_set_lines(btn_buf_id, 0, -1, false, { "[ " .. labelButton .. " ]" })
    vim.api.nvim_buf_set_option(btn_buf_id, "modifiable", false)

    if labelButton == "Git init" then
        vim.api.nvim_buf_set_keymap(btn_buf_id, "n", "<CR>", ":lua _G.confirm_input()<CR>", { noremap = true, silent = true })
    elseif labelButton == "link GitHub" then
        vim.api.nvim_buf_set_keymap(btn_buf_id, "n", "<CR>", ":lua _G.close_input_link()<CR>", { noremap = true, silent = true })
    elseif labelButton == "name Rama" then
        vim.api.nvim_buf_set_keymap(btn_buf_id, "n", "<CR>", ":lua _G.close_input_rama()<CR>", { noremap = true, silent = true })
    elseif labelButton == "name File" then
        vim.api.nvim_buf_set_keymap(btn_buf_id, "n", "<CR>", ":lua _G.close_input_add()<CR>", { noremap = true, silent = true })
    elseif labelButton == "go Commit" then
        vim.api.nvim_buf_set_keymap(btn_buf_id, "n", "<CR>", ":lua _G.close_input_commit()<CR>", { noremap = true, silent = true })
    elseif labelButton == "go Push" then
        vim.api.nvim_buf_set_keymap(btn_buf_id, "n", "<CR>", ":lua _G.close_input_push()<CR>", { noremap = true, silent = true })
    elseif labelButton == "del .Git" then
        vim.api.nvim_buf_set_keymap(btn_buf_id, "n", "<CR>", ":lua _G.close_input_delGit()<CR>", { noremap = true, silent = true })
    end
end

-- Función para obtener el texto ingresado y mostrarlo
function _G.confirm_input()
    print("git init ")
    _G.execute_command("git init", 0)
    _G.close_input_window()

end
function _G.execute_command(command, terminal)
    if file_dir and file_dir ~= "" then
        if terminal == 1 then
            vim.cmd("new | terminal cd " .. file_dir .. " && " .. command) 
        else
            vim.fn.jobstart("cd " .. file_dir .. " && " .. command, { detach = true })
        end
    else
        print("Error: No se pudo determinar la ruta del archivo.")
    end
end
function _G.close_input_delGit()
    _G.execute_command("rm -rf .git", 0)
    vim.api.nvim_win_close(btn_win_id, true)

end
function _G.close_input_push()
    _G.execute_command(string.format("git push -u origin %s", nameRama), 1)
    vim.api.nvim_win_close(btn_win_id, true)
    _G.create_confirm_button("del .Git")


end
function _G.close_input_commit()
    _G.execute_command(string.format("git commit -m '%s'", nameRama), 0)
    vim.api.nvim_win_close(btn_win_id, true)
    _G.create_confirm_button("go Push")

    
end
function _G.close_input_add()
    local input_text = vim.api.nvim_buf_get_lines(input_buf_id, 0, -1, false)[1]
    _G.execute_command(string.format("git add %s", input_text), 0)
    
    vim.api.nvim_win_close(input_win_id, true)
    vim.api.nvim_win_close(btn_win_id, true)
     _G.create_confirm_button("go Commit")
end 

function _G.close_input_rama()
    local input_text = vim.api.nvim_buf_get_lines(input_buf_id, 0, -1, false)[1]
    _G.execute_command(string.format("git checkout -b %s", input_text), 0)
    nameRama = input_text
    vim.api.nvim_win_close(btn_win_id, true)
    _G.create_confirm_button("name File")
    vim.api.nvim_set_current_win(input_win_id) -- Mueve el foco al botón
    vim.api.nvim_buf_set_lines(input_buf_id, 0, -1, false, { "" })
end

function _G.close_input_link()
    -- Primero, obtener el texto ingresado
    local input_text = vim.api.nvim_buf_get_lines(input_buf_id, 0, -1, false)[1]

    -- Luego, ejecutar el comando usando el texto capturado
    _G.execute_command(string.format("git remote add origin %s.git", input_text), 0)

    vim.api.nvim_win_close(btn_win_id, true)
    _G.create_confirm_button("name Rama")
    vim.api.nvim_set_current_win(input_win_id) -- Mueve el foco al botón
    vim.api.nvim_buf_set_lines(input_buf_id, 0, -1, false, { "" })
end

-- Función para cerrar las ventanas
function _G.close_input_window()
    _G.create_input_window()
     vim.api.nvim_win_close(btn_win_id, true)
    _G.create_confirm_button("link GitHub")
     vim.api.nvim_set_current_win(input_win_id) -- Mueve el foco al botón
end

-- Función principal para abrir ambas ventanas
function _G.show_input_interface()
    _G.capture_file_dir() 
    _G.create_confirm_button("Git init")

end

-- Atajo para abrir la ventana con "f"
vim.api.nvim_set_keymap("n", "c", ":lua _G.show_input_interface()<CR>", { noremap = true, silent = true })

    
--git config --global credential.helper store
--guarda las credeciales para de usuario y token
--para escribir solo una vez

local input_win_id, input_buf_id, btn_win_id, btn_buf_id
local file_direx =  "manuel"
local nameRama
local files_to_add = {}
local prev_terminal_win_id = nil  -- ID de terminal anterior
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
        vim.api.nvim_set_current_win(btn_win_id)
    end
end

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

    local map = {
        ["Git init"] = "_G.confirm_input",
        ["link GitHub"] = "_G.close_input_link",
        ["name Rama"] = "_G.close_input_rama",
        ["name File"] = "_G.close_input_add",
        ["go Commit"] = "_G.close_input_commit",
        ["go Push"] = "_G.close_input_push",
        ["del .Git"] = "_G.close_input_delGit",
    }

    if map[labelButton] then
        vim.api.nvim_buf_set_keymap(btn_buf_id, "n", "<CR>", ":lua " .. map[labelButton] .. "()<CR>", { noremap = true, silent = true })
    end
end

function _G.confirm_input()
    print("git init")
    _G.execute_commandx("git init", 1)
    _G.close_input_window()
end

function _G.execute_commandx(command, terminal)
    
    if terminal == 1 then
        if prev_terminal_win_id and vim.api.nvim_win_is_valid(prev_terminal_win_id) then
            vim.api.nvim_win_close(prev_terminal_win_id, true)
        end

        vim.cmd("botright new")
        prev_terminal_win_id = vim.api.nvim_get_current_win()
        vim.cmd("terminal cd " .. file_direx .. " && " .. command)
    else
        vim.fn.jobstart("cd " .. file_direx .. " && " .. command, { detach = true })
    end
end

function _G.close_input_delGit()
    files_to_add = {}
    _G.execute_commandx("rm -rf .git", 1)
    vim.api.nvim_win_close(btn_win_id, true)
end

function _G.close_input_push()
    _G.execute_commandx(string.format("git push -u origin %s", nameRama), 1)
    vim.api.nvim_win_close(btn_win_id, true)
    _G.create_confirm_button("del .Git")
end

function _G.close_input_commit()
    _G.execute_commandx(string.format("git commit -m '%s'", nameRama), 1)
    vim.api.nvim_win_close(btn_win_id, true)
    _G.create_confirm_button("go Push")
end

function _G.close_input_add()
    local input_text = vim.api.nvim_buf_get_lines(input_buf_id, 0, -1, false)[1]

    if input_text == "done" then
        if #files_to_add > 0 then
            local all_files = table.concat(files_to_add, " ")
            _G.execute_commandx(string.format("git add %s", all_files), 1)
            vim.api.nvim_win_close(input_win_id, true)
            vim.api.nvim_win_close(btn_win_id, true)
            _G.create_confirm_button("go Commit")
        else
            print("No se han agregado archivos.")
        end
        return
    end

    table.insert(files_to_add, input_text)
    print("Archivo agregado: " .. input_text)

    vim.api.nvim_buf_set_lines(input_buf_id, 0, -1, false, { "" })
end

function _G.close_input_rama()
    local input_text = vim.api.nvim_buf_get_lines(input_buf_id, 0, -1, false)[1]
    _G.execute_commandx(string.format("git checkout -b %s", input_text), 1)
    nameRama = input_text
    vim.api.nvim_win_close(btn_win_id, true)
    _G.create_confirm_button("name File")
    vim.api.nvim_set_current_win(input_win_id)
    vim.api.nvim_buf_set_lines(input_buf_id, 0, -1, false, { "archivo.txt o 'done' para seguir" })
end

function _G.close_input_link()
    local input_text = vim.api.nvim_buf_get_lines(input_buf_id, 0, -1, false)[1]
    _G.execute_commandx(string.format("git remote add origin %s.git", input_text), 1)
    vim.api.nvim_win_close(btn_win_id, true)
    _G.create_confirm_button("name Rama")
    vim.api.nvim_set_current_win(input_win_id)
    vim.api.nvim_buf_set_lines(input_buf_id, 0, -1, false, { "" })
end

function _G.close_input_window()
    _G.create_input_window()
    vim.api.nvim_win_close(btn_win_id, true)
    _G.create_confirm_button("link GitHub")
    vim.api.nvim_set_current_win(input_win_id)
end

function _G.show_input_interface()
    file_direx = vim.fn.expand("%:p:h")
    if file_direx ~= "" then
        vim.fn.setreg("+", file_direx)
        print("Ruta copiada al portapapeles: " .. file_direx)
    end

    _G.create_confirm_button("Git init")
end

vim.api.nvim_set_keymap("n", "th", ":lua _G.show_input_interface()<CR>", { noremap = true, silent = true })

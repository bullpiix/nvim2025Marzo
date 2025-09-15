
local input1_buf_id, input1_win_id
local input2_buf_id, input2_win_id
local label1_buf_id, label1_win_id
local label2_buf_id, label2_win_id
local input1_text = ""
vim.g.xbuscar = "manuel"
function _G.start_dual_input()
    label1_buf_id = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(label1_buf_id, 0, -1, false, { "Buscar" })
    label1_win_id = vim.api.nvim_open_win(label1_buf_id, false, {
        relative = "editor",
        width = 30,
        height = 1,
        row = 1,
        col = vim.o.columns - 34,
        style = "minimal",
        noautocmd = true,
    })
    -- Crear primer input
    input1_buf_id = vim.api.nvim_create_buf(false, true)
    input1_win_id = vim.api.nvim_open_win(input1_buf_id, true, {
        relative = "editor",
        width = 30,
        height = 1,
        row = 2,
        col = vim.o.columns - 34,
        style = "minimal",
        border = "rounded",
    })

    vim.api.nvim_buf_set_option(input1_buf_id, "modifiable", true)
    vim.api.nvim_buf_set_option(input1_buf_id, "buftype", "prompt")
    vim.fn.prompt_setprompt(input1_buf_id, "-> ")
    vim.fn.prompt_setcallback(input1_buf_id, function(input)
        input1_text = input or ""
        vim.api.nvim_set_current_win(input2_win_id)
        vim.schedule(function()
            vim.cmd("startinsert")
        end)
    end)
    vim.api.nvim_buf_set_keymap(
        input1_buf_id,
        "i",
        "<Space>",
        [[<C-\><C-n>:lua _G.get_line()<CR>]],
        { noremap= true, silent=true}
    )
    label2_buf_id = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(label2_buf_id, 0, -1, false, { "Remplazar" })
    label2_win_id = vim.api.nvim_open_win(label2_buf_id, false, {
        relative = "editor",
        width = 30,
        height = 1,
        row = 5,
        col = vim.o.columns - 34,
        style = "minimal",
        noautocmd = true,
    })
    -- Crear segundo input (sin focus todavía)
    input2_buf_id = vim.api.nvim_create_buf(false, true)
    input2_win_id = vim.api.nvim_open_win(input2_buf_id, false, {
        relative = "editor",
        width = 30,
        height = 1,
        row = 6,
        col = vim.o.columns - 34,
        style = "minimal",
        border = "rounded",
    })
    vim.api.nvim_buf_set_option(input2_buf_id, "modifiable", true)
    vim.api.nvim_buf_set_option(input2_buf_id, "buftype", "prompt")
    vim.fn.prompt_setprompt(input2_buf_id, "-> ")
    vim.fn.prompt_setcallback(input2_buf_id, function(input2_text)
        vim.api.nvim_win_close(input1_win_id, true)
        vim.api.nvim_win_close(input2_win_id, true)
        vim.api.nvim_win_close(label1_win_id, true)
        vim.api.nvim_win_close(label2_win_id, true)
    end)
    vim.api.nvim_buf_set_keymap(
        input2_buf_id,
        "i",
        "<Space>",
        [[<C-\><C-n>:lua _G.set_line()<CR>]], 
        { noremap = true, silent= true}
    )
    vim.cmd("startinsert")
end
function _G.get_line()
    local line = vim.api.nvim_get_current_line()
    local input= line:gsub("^->%s*", "")
    vim.fn.feedkeys("/" .. vim.fn.escape(input, "/\\") .. "\n", "n") 
    vim.api.nvim_set_current_win(input2_win_id)
    vim.schedule(function()
        vim.cmd("startinsert")
    end)
end
function _G.set_line()
    local line = vim.api.nvim_get_current_line()
    local input = line:gsub("^->%s*", "")
    vim.g.xbuscar=input
    vim.api.nvim_win_close(input1_win_id, true)
    vim.api.nvim_win_close(input2_win_id, true)
    vim.api.nvim_win_close(label1_win_id, true)
    vim.api.nvim_win_close(label2_win_id, true)
end
vim.api.nvim_set_keymap("n", "3", ":lua _G.start_dual_input()<CR>" ,{ noremap = true, silent= true})
vim.keymap.set('n', '4', function()
  vim.cmd('normal! cgn' .. vim.g.xbuscar .. '\027')  -- \027 = <Esc>
end, { noremap = true, silent = true })
-- buscar palabra con "n" y remplazar palabra con  "4"

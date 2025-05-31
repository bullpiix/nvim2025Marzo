

local lspconfig = require('lspconfig')

-- Configurar pyright sin mostrar los diagnósticos
lspconfig.pyright.setup({
  on_attach = function(client, bufnr)
    -- Desactivar los diagnósticos
    vim.lsp.diagnostic.disable()

    -- Asignar el comando para mostrar documentación al presionar 'K'
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', ':lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
  end,
  handlers = {
    -- Desactivar diagnósticos (errores, advertencias, etc.)
    ["textDocument/publishDiagnostics"] = function() end
  }
})


vim.api.nvim_set_keymap('n', 'R', [[<cmd>lua vim.lsp.buf.document_symbol()<CR>]], { noremap = true, silent = true })

function ShowOnlyFunctions1()
  local params = { textDocument = vim.lsp.util.make_text_document_params() }
  vim.lsp.buf_request(0, 'textDocument/documentSymbol', params, function(err, result, ctx, config)
    if err or not result then return end

    local functions = {}
    for _, symbol in ipairs(result) do
      if symbol.kind == 12 then  -- 12 es el código para funciones en LSP
        table.insert(functions, string.format("%s|%d col %d| [Function] %s",
          vim.api.nvim_buf_get_name(0), symbol.range.start.line + 1, symbol.range.start.character + 1, symbol.name))
      end
    end

    if #functions == 0 then
      print("No functions found.")
    else
      print(table.concat(functions, "\n"))
    end
  end)
end

--vim.api.nvim_set_keymap('n', 'E', ':lua ShowOnlyFunctions()<CR>', { noremap = true, silent = true })

function ShowCurrentFunction()
  local params = { textDocument = vim.lsp.util.make_text_document_params() }
  vim.lsp.buf_request(0, 'textDocument/documentSymbol', params, function(err, result, ctx, config)
    if err or not result then return end

    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local cursor_line = cursor_pos[1] - 1 -- Convertir a base 0
    local cursor_col = cursor_pos[2]

    local current_function = nil

    for _, symbol in ipairs(result) do
      if symbol.kind == 12 then  -- 12 es el código para funciones en LSP
        local start_line = symbol.range.start.line
        local end_line = symbol.range["end"].line

        if cursor_line >= start_line and cursor_line <= end_line then
          current_function = string.format("%s|%d col %d| [Function] %s",
            vim.api.nvim_buf_get_name(0), start_line + 1, symbol.range.start.character + 1, symbol.name)
          break
        end
      end
    end

    if current_function then
      print(current_function)
    else
      print("No function found at cursor position.")
    end
  end)
end

vim.api.nvim_set_keymap('n', 'D', ':lua ShowCurrentFunction()<CR>', { noremap = true, silent = true })



function ShowCurrentMethod()
  local params = { textDocument = vim.lsp.util.make_text_document_params() }
  vim.lsp.buf_request(0, 'textDocument/documentSymbol', params, function(err, result, ctx, config)
    if err or not result then return end

    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local cursor_line = cursor_pos[1] - 1 -- Convertir a base 0
    local cursor_col = cursor_pos[2]

    local current_method = nil

    local function find_method(symbols)
      for _, symbol in ipairs(symbols) do
        if symbol.kind == 6 then  -- 6 es el código para métodos en LSP
          local start_line = symbol.range.start.line
          local end_line = symbol.range["end"].line

          if cursor_line >= start_line and cursor_line <= end_line then
            current_method = string.format("%s|%d col %d| [Method] %s",
              vim.api.nvim_buf_get_name(0), start_line + 1, symbol.range.start.character + 1, symbol.name)
            break
          end
        end

        if symbol.children then
          find_method(symbol.children)
        end
      end
    end

    find_method(result)

    if current_method then
      print(current_method)
    else
      print("No method found at cursor positionManu.")
    end
  end)
end

vim.api.nvim_set_keymap('n', 'E', ':lua ShowCurrentMethod()<CR>', { noremap = true, silent = true })

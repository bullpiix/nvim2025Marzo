

-- Requiere nvim-cmp
local cmp = require('cmp')

-- Ruta al archivo externo para autocompletado
local custom_file_path = "/home/manutip/Downloads/lib.dom.d.ts"

-- Función para extraer palabras únicas del archivo
local function get_words_from_file()
  local words = {}
  local seen = {}
  local f = io.open(custom_file_path, "r")
  if f then
    for line in f:lines() do
      for word in line:gmatch("[a-zA-Z_][a-zA-Z0-9_]*") do
        if not seen[word] then
          table.insert(words, { label = word })
          seen[word] = true
        end
      end
    end
    f:close()
  end
  return words
end

-- Fuente personalizada para nvim-cmp
local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

source.complete = function(_, _, callback)
  local items = get_words_from_file()
  callback({ items = items, isIncomplete = false })
end

-- Registrar la fuente personalizada
require("cmp").register_source("custom_file", source.new())

-- Configurar cmp


cmp.setup({
  mapping = {
    ['<Down>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
  },
  sources = cmp.config.sources({
    { name = 'buffer', option = { max_item_count = 5 } },
    { name = 'custom_file', option = { max_item_count = 5 } },
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  performance = {
    max_view_entries = 10,
  },
})

local function set_cmp_sources(source_list)
  cmp.setup({
    sources = source_list,
  })
end

-- Tecla F2: usar fuente buffer
vim.keymap.set('i', '<F2>', function()
  set_cmp_sources({
    { name = 'buffer', option = { max_item_count = 10 } }
  })
  print("cmp: usando fuente 'buffer'")
end)

-- Tecla F3: volver a fuente personalizada
vim.keymap.set('i', '<F1>', function()
  set_cmp_sources({
    { name = 'custom_file' }
  })
  print("cmp: usando fuente 'custom_file'")
end)
vim.keymap.set('i', '<F3>', function()
  set_cmp_sources({
    { name = 'buffer', option = { max_item_count = 5 } },
    { name = 'custom_file', option = { max_item_count = 5 } }
  })
  print("cmp: usando mix 'buffer + custom_file'")
end)

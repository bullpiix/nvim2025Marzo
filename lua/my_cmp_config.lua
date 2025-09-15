-- lua/cmp.lua
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      -- Si usas luasnip, actívalo aquí. Si no, comenta esta línea.
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Up>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp", max_item_count = 5 },
    { name = "buffer", max_item_count = 5 },
    { name = "path", max_item_count = 5 },   
  }),
})  

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
    ["<Space>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },  -- ✅ Esta es la clave para usar el LSP
    { name = "buffer" },
    { name = "path" },
  }),
})  

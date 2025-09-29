vim.opt.runtimepath:remove("/usr/share/nvim/runtime/lua/vim/treesitter")
require('boxRun')
require('mygit')
require('manuSetup')
require("my_cmp_config")  -- Tu archivo cmp.lua
require("manuBuscar") 
require("busca_rempla")
require("relative")
require("treeExplorer")
-- 
require('packer').startup(function(use)
  
    use 'wbthomason/packer.nvim'
    use 'hrsh7th/nvim-cmp'         -- Plugin principal de autocompletado
    use 'hrsh7th/cmp-buffer'       -- Fuente para el buffer actual
   use {
      "ibhagwan/fzf-lua",
      requires = { "nvim-tree/nvim-web-devicons" } -- opcional
    }
   use {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- opcional, pero recomendado
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("neo-tree").setup({
            filesystem = {
                window = {
                  mappings = {
                    ["o"] = "open", -- asigna "i" a la acción de abrir archivo/carpeta
                  }
                }
              }
        })
      end
    }
    use { "NLKNguyen/papercolor-theme" }
end)


vim.o.background = "light"
vim.cmd.colorscheme("PaperColor")

-- Fuente para Neovide
vim.o.guifont = "DejaVu Sans Mono:h24"

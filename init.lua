require('boxRun')
require('mygit')
require('manuSetup')
require("my_cmp_config")  -- Tu archivo cmp.lua
require("manuBuscar") 
require("busca_rempla")
require("relative")
require("treeExplorer")

require('packer').startup(function(use)
  
    use 'wbthomason/packer.nvim'
    use 'hrsh7th/nvim-cmp'         -- Plugin principal de autocompletado
    use 'hrsh7th/cmp-buffer'       -- Fuente para el buffer actual
      use {
      "projekt0n/github-nvim-theme",
      priority = 1000, -- Asegura que cargue antes que otros
      config = function()
        require("github-theme").setup({
          theme_style = "light", -- opciones: "light", "dark", "dimmed"
        })
        vim.cmd("colorscheme github_light")
      end
    }
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

end)

-- Fuente para Neovide
vim.o.guifont = "DejaVu Sans Mono:h24"

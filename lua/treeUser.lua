

local ts_utils = require("nvim-treesitter.ts_utils")

function GoToHtmlClosingTag()
  local node = ts_utils.get_node_at_cursor()
  while node do
    if node:type() == "element" then
      for child in node:iter_children() do
        if child:type() == "end_tag" then
          local start_row, start_col = child:start()
          vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
          return
        end
      end
    end
    node = node:parent()
  end
  print("No closing tag found")
end

vim.keymap.set("n", "<Space>-", GoToHtmlClosingTag, { desc = "Ir al cierre </div>" })

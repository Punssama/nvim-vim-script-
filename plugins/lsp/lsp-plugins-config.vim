" By default timeoutlen is 1000 ms
lua << END
---which key
vim.opt.timeoutlen = 300
vim.opt.updatetime = 100

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
     ["<leader>"] = "SPACE",
     ["<space>"] = "SPC",
     ["<C>"] = "CTRL",
     ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-j>", -- binding to scroll down inside the popup
    scroll_up = "<c-k>", -- binding to scroll up inside the popup
  },
  window = {
    border = "rounded", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
  ["w"] = { "<cmd>w!<CR>", "Save" },
  ["q"] = { "<cmd>q<CR>", "Quit" },
  ["f"] = {"<cmd>Telescope find_files hidden=true<cr>","Find files"},
  ["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
  ["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
  ["n"] = {"<cmd>tabedit<cr>", "New tab"},
  ["/"] = {"<cmd>Commentary<cr>", "Comment"},

  g = {
    name = "Git",
    g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    d = {
      "<cmd>Gitsigns diffthis HEAD<cr>",
      "Diff",
    },
  },

  s = {
    name = "Search",
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
  },

  t = {
    name = "Terminal",
    f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
    v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
  },

  T = {
    name = "TreeSitter",
    i = {"<cmd>TSConfigInfo<cr>", "Info"}
    },
  
  L = {
    name = "Clear",
    u = {"<cmd>!rm -rf ~/.vim/undo <cr>", "Clear undo cache"},
    l = {"<cmd>LuaCacheClear<cr>", "Clear lua cache"}
    },
  c = {
    name = "Coc-nvim",
    s = {"<cmd>Cocstart<cr>", "Start Coc"},
    r = {"<cmd>CocRestart<cr>", "Restart Coc"},
    i = {"<cmd>PlugInstall<cr>", "Coc install plugin"},
    u = {"<cmd>CocUpdate<cr>", "Coc update"},
    d = {"<cmd>CocDiagnostics<cr>", "Diagnostics"},
    },
  l = {
    name = "Lime light",
    o = {
      name = "options [0.1 ~> 1.0]",
      ["1"] = {"<cmd>Limelight0.1<cr>", "light level:0,1"},
      ["2"] = {"<cmd>Limelight0.2<cr>", "light level:0,2"},
      ["3"] = {"<cmd>Limelight0.3<cr>", "light level:0,3"},
      ["4"] = {"<cmd>Limelight0.4<cr>", "light level:0,4"},
      ["5"] = {"<cmd>Limelight0.5<cr>", "light level:0,5"},
      ["6"] = {"<cmd>Limelight0.6<cr>", "light level:0,6"},
      ["7"] = {"<cmd>Limelight0.7<cr>", "light level:0,7"},
      ["8"] = {"<cmd>Limelight0.8<cr>", "light level:0,8"},
      ["9"] = {"<cmd>Limelight0.9<cr>", "light level:0,9"},
      m = {"<cmd>Limelight1<cr>", "light level:1"},
    },
    f = {"<cmd>Limelight!<cr>", "Lime light off"}
    },
  ["<F5>"] = {
    name = "Run",
    n = {"<cmd>!node % <cr>", "Run current JavaScript file"},
    p = {"<cmd>!python3 %<cr>", "Run current Python3 file"},

    --add your run commands below--
    }
}
  


which_key.setup(setup)
which_key.register(mappings, opts)




require('filetype').setup {}
vim.g.did_load_filtypes = 1

_G.__luacache_config = {
  chunks = {
    enable = true,
    path = vim.fn.stdpath('cache')..'/luacache_chunks',
  },
  modpaths = {
    enable = true,
    path = vim.fn.stdpath('cache')..'/luacache_modpaths',
  }
}
require('impatient')
require'impatient'.enable_profile()

END




lua << END
require('lualine').setup {
  options = {
      incons_enabled = true,
      theme = 'auto',
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {}
    },
sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch',
      'diagnostics',
     },
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}  
}

require('bufferline').setup {
  options = {
    mode = "buffers",
    show_tab_indicators = true,
    seperator_style = "thin",
    diagnostics = "coc",

    }
  }
END

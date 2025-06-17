return {
  "folke/snacks.nvim",
  dependencies = {
    "echasnovski/mini.icons",
  },
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
                header = [[
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
        ]],
          },
        },
    indent = { enabled = true },
    input = { enabled = true },
    git = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    { "<leader>sf",  function() Snacks.scratch() end },
    { "<leader>S",   function() Snacks.scratch.select() end },
    { "<leader>gl",  function() Snacks.lazygit.log_file() end },
    { "<leader>lg",  function() Snacks.lazygit() end },
    { "<C-p>",       function() Snacks.picker.pick("files") end },
    { "<leader><leader>", function() Snacks.picker.recent() end },
    { "<leader>fb",  function() Snacks.picker.buffers() end },
    { "<leader>fg",  function() Snacks.picker.grep() end },
    { "<C-n>",       function() Snacks.explorer() end },
  }
}

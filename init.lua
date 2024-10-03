-- =========================================
-- Neovim Configuration File (init.lua)
-- =========================================

-- [[ Leader Key Setup ]]
-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting Options ]]
vim.opt.number = true                      -- Show line numbers
vim.opt.mouse = 'a'                        -- Enable mouse support
vim.opt.showmode = false                   -- Don't show mode since we have a status line
vim.opt.clipboard = 'unnamedplus'          -- Use system clipboard
vim.opt.breakindent = true                 -- Enable break indent
vim.opt.undofile = true                    -- Enable persistent undo
vim.opt.ignorecase = true                  -- Ignore case in searches
vim.opt.smartcase = true                   -- Override ignorecase if search contains capitals
vim.opt.signcolumn = 'yes'                 -- Always show sign column
vim.opt.updatetime = 250                   -- Faster completion
vim.opt.timeoutlen = 300                   -- Faster key mappings
vim.opt.splitright = true                  -- Vertical splits to the right
vim.opt.splitbelow = true                  -- Horizontal splits below
vim.opt.list = true                        -- Show some invisible characters
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'                -- Show incremental command previews
vim.opt.cursorline = true                  -- Highlight the current line
vim.opt.scrolloff = 10                     -- Keep 10 lines visible around the cursor

-- [[ Basic Keymaps ]]
local keymap = vim.keymap
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic list' })
keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Focus left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Focus right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Focus below window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Focus above window' })

-- [[ Autocommands ]]
-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Plugin Manager: lazy.nvim ]]
-- Install `lazy.nvim` if not already installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and Install Plugins ]]
require('lazy').setup({
  -- Basic Plugins
  'tpope/vim-sleuth',

  -- Git Signs
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Which-Key for keybinding hints
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up>', Down = '<Down>', Left = '<Left>', Right = '<Right>',
          C = '<C-…>', M = '<M-…>', D = '<D-…>', S = '<S-…>',
          CR = '<CR>', Esc = '<Esc>', ScrollWheelDown = '<ScrollWheelDown>',
          ScrollWheelUp = '<ScrollWheelUp>', NL = '<NL>', BS = '<BS>',
          Space = '<Space>', Tab = '<Tab>', F1 = '<F1>', F2 = '<F2>',
          F3 = '<F3>', F4 = '<F4>', F5 = '<F5>', F6 = '<F6>',
          F7 = '<F7>', F8 = '<F8>', F9 = '<F9>', F10 = '<F10>',
          F11 = '<F11>', F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- Telescope for fuzzy finding
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = vim.fn.executable('make') == 1 },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require('telescope.builtin')
      local keymap = vim.keymap
      keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
      keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })
      keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
      end, { desc = 'Fuzzily search in current buffer' })
      keymap.set('n', '<leader>s/', function()
        builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
      end, { desc = 'Search in Open Files' })
      keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath('config') }
      end, { desc = 'Search Neovim files' })
    end,
  },

  -- LazyDev for Lua development
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },

  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
      }

      require('mason').setup()
      require('mason-tool-installer').setup { ensure_installed = vim.tbl_keys(servers) }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- LSP Keybindings
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach', { clear = true }),
        callback = function(event)
          local opts = { buffer = event.buf }
          local map = function(keys, func, desc, modes)
            modes = modes or { 'n' }
            for _, mode in ipairs(modes) do
              vim.keymap.set(mode, keys, func, vim.tbl_extend('force', opts, { desc = desc }))
            end
          end

          local builtin = require('telescope.builtin')
          map('gd', builtin.lsp_definitions, 'Goto Definition')
          map('gr', builtin.lsp_references, 'Goto References')
          map('gI', builtin.lsp_implementations, 'Goto Implementation')
          map('<leader>D', builtin.lsp_type_definitions, 'Type Definition')
          map('<leader>ds', builtin.lsp_document_symbols, 'Document Symbols')
          map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, 'Workspace Symbols')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local augroup = vim.api.nvim_create_augroup('lsp_highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp_detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp_highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle Inlay Hints')
          end
        end,
      })
    end,
  },

  -- Code Formatter: conform.nvim
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback'
        return { timeout_ms = 500, lsp_format = lsp_format_opt }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
      },
    },
  },

  -- Completion Engine: nvim-cmp
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 and nil or 'make install_jsregexp',
      },
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete {},
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        sources = {
          { name = 'lazydev', group_index = 0 },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  -- Colorscheme: Tokyo Night
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme('tokyonight-night')
      vim.cmd.hi('Comment gui=none')
    end,
  },

  -- Todo Comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- Mini Plugins
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require('mini.statusline')
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- Treesitter for syntax highlighting and more
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

  -- [[ File Explorer: nvim-tree.lua ]]
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- Optional: for file icons
    },
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' },
    keys = {
      { '<leader>f', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle File Explorer' },
      { '<leader>o', '<cmd>NvimTreeFindFile<CR>', desc = 'Find File in Explorer' },
    },
    opts = {
      sort_by = "name",
      view = {
        width = 30,
        side = 'left',
        mappings = {
          custom_only = false, -- Ensure that both default and custom mappings are used
          list = {
            { key = { "l", "<CR>", "o" }, action = "edit" },
            { key = "h", action = "close_node" },
            { key = "v", action = "vsplit" },
          },
        },
      },
      renderer = {
        icons = {
          glyphs = {
            folder = {
              default = "📁",
              open = "📂",
              empty = "📂",
              empty_open = "📂",
              symlink = "🔗",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      filters = {
        dotfiles = false,
      },
      actions = {
        open_file = {
          resize_window = true,
        },
      },
    },
  },

  -- [[ Custom Dashboard: alpha.nvim ]]
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Optional: for icons
    event = 'VimEnter',
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')

      -- Custom ASCII Art Header
      dashboard.section.header.val = {
        " ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
        " ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
        " ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
        " ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        " ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }

      -- Buttons
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New File", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "🔍  Find File", ":Telescope find_files <CR>"),
        dashboard.button("r", "📂  Recently Used", ":Telescope oldfiles <CR>"),
        dashboard.button("s", "🔧  Settings", ":e $MYVIMRC <CR>"),
        dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
      }

      -- Footer (optional)
      dashboard.section.footer.val = { "Welcome to Neovim!" }

      -- Highlighting
      dashboard.section.header.opts.hl = 'Type'
      dashboard.section.buttons.opts.hl = 'Keyword'
      dashboard.section.footer.opts.hl = 'Constant'

      -- Layout adjustments
      dashboard.opts.layout[1].val = 8 -- Top padding
      dashboard.opts.opts.noautocmd = true

      alpha.setup(dashboard.opts)
    end,
  },

}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙', keys = '🗝',
      plugin = '🔌', runtime = '💻', require = '🌙', source = '📄', start = '🚀',
      task = '📌', lazy = '💤 ',
    },
  },
})

-- [[ Optional: Open nvim-tree on startup ]]
-- Uncomment the following block if you want nvim-tree to open automatically on startup
-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     require("nvim-tree.api").tree.toggle()
--   end,
-- })

-- [[ Optional: Keybinding to toggle dashboard ]]
-- If you want to toggle the dashboard manually, set up a keybinding like below
-- keymap.set('n', '<leader>d', ':Alpha<CR>', { desc = 'Open Dashboard' })

-- [[ Modeline ]]
-- vim: ts=2 sts=2 sw=2 et

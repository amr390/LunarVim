CONFIG_PATH = os.getenv "HOME" .. "/.local/share/lunarvim/lvim"
DATA_PATH = vim.fn.stdpath "data"
CACHE_PATH = vim.fn.stdpath "cache"
TERMINAL = vim.fn.expand "$TERMINAL"
USER = vim.fn.expand "$USER"
vim.cmd [[ set spellfile=~/.config/lvim/spell/en.utf-8.add ]]

lvim = {
  leader = "space",
  colorscheme = "spacegray",
  line_wrap_cursor_movement = true,
  transparent_window = false,
  format_on_save = true,
  vsnip_dir = os.getenv "HOME" .. "/.config/snippets",
  database = { save_location = "~/.config/lunarvim_db", auto_execute = 1 },
  keys = {},

  -- TODO why do we need this?
  builtin = {
    lspinstall = {},
    telescope = {},
    compe = {},
    autopairs = {},
    treesitter = {},
    nvimtree = {},
    gitsigns = {},
    which_key = {},
    comment = {},
    rooter = {},
    galaxyline = {},
    bufferline = {},
    dap = {},
    dashboard = {},
    terminal = {},
  },

  log = {
    ---@usage can be { "trace", "debug", "info", "warn", "error", "fatal" },
    level = "warn",
    viewer = {
      ---@usage this will fallback on "less +F" if not found
      cmd = "lnav",
      layout_config = {
        ---@usage direction = 'vertical' | 'horizontal' | 'window' | 'float',
        direction = "horizontal",
        open_mapping = "",
        size = 40,
        float_opts = {},
      },
    },
  },

  lsp = {
    completion = {
      item_kind = {
        "   (Text) ",
        "   (Method)",
        "   (Function)",
        "   (Constructor)",
        " ﴲ  (Field)",
        "[] (Variable)",
        "   (Class)",
        " ﰮ  (Interface)",
        "   (Module)",
        " 襁 (Property)",
        "   (Unit)",
        "   (Value)",
        " 練 (Enum)",
        "   (Keyword)",
        "   (Snippet)",
        "   (Color)",
        "   (File)",
        "   (Reference)",
        "   (Folder)",
        "   (EnumMember)",
        " ﲀ  (Constant)",
        " ﳤ  (Struct)",
        "   (Event)",
        "   (Operator)",
        "   (TypeParameter)",
      },
    },
    diagnostics = {
      signs = {
        active = true,
        values = {
          { name = "LspDiagnosticsSignError", text = "" },
          { name = "LspDiagnosticsSignWarning", text = "" },
          { name = "LspDiagnosticsSignHint", text = "" },
          { name = "LspDiagnosticsSignInformation", text = "" },
        },
      },
      virtual_text = {
        prefix = "",
        spacing = 0,
      },
      underline = true,
      severity_sort = true,
    },
    override = {},
    document_highlight = true,
    popup_border = "single",
    on_attach_callback = nil,
    on_init_callback = nil,
    ---@usage query the project directory from the language server and use it to set the CWD
    smart_cwd = true,
  },

  plugins = {
    -- use config.lua for this not put here
  },

  autocommands = {},
}

local schemas = nil
local lsp = require "lsp"
local common_on_attach = lsp.common_on_attach
local common_capabilities = lsp.common_capabilities()
local common_on_init = lsp.common_on_init
local status_ok, jsonls_settings = pcall(require, "nlspsettings.jsonls")
if status_ok then
  schemas = jsonls_settings.get_default_schemas()
end

-- TODO move all of this into lang specific files, only require when using
lvim.lang = {
  asm = {
    formatters = {
      {
        -- @usage can be asmfmt
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "",
      setup = {},
    },
  },
  beancount = {
    formatters = {
      {
        -- @usage can be bean_format
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "beancount",
      setup = {
        cmd = { "beancount-langserver" },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  c = {
    formatters = {
      {
        -- @usage can be clang_format or uncrustify
        exe = "",
        args = {},
        stdin = true,
      },
    },
    linters = {},
    lsp = {
      provider = "clangd",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/cpp/clangd/bin/clangd",
          "--background-index",
          "--header-insertion=never",
          "--cross-file-rename",
          "--clang-tidy",
          "--clang-tidy-checks=-*,llvm-*,clang-analyzer-*",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  cpp = {
    formatters = {
      {
        -- @usage can be clang_format or uncrustify
        exe = "",
        args = {},
        stdin = true,
      },
    },
    linters = {},
    lsp = {
      provider = "clangd",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/cpp/clangd/bin/clangd",
          "--background-index",
          "--header-insertion=never",
          "--cross-file-rename",
          "--clang-tidy",
          "--clang-tidy-checks=-*,llvm-*,clang-analyzer-*",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  crystal = {
    formatters = {
      {
        -- @usage can be crystal_format
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "crystalline",
      setup = {
        cmd = { "crystalline" },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  cs = {
    formatters = {
      {
        -- @usage can be clang_format or uncrustify
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "omnisharp",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/csharp/omnisharp/run",
          "--languageserver",
          "--hostPID",
          tostring(vim.fn.getpid()),
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  cmake = {
    formatters = {
      {
        -- @usage can be cmake_format
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "cmake",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/cmake/venv/bin/cmake-language-server",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  clojure = {
    formatters = { {
      exe = "",
      args = {},
    } },
    linters = {},
    lsp = {
      provider = "clojure_lsp",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/clojure/clojure-lsp",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  css = {
    formatters = {
      {
        -- @usage can be prettier or prettierd
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "cssls",
      setup = {
        cmd = {
          "node",
          DATA_PATH .. "/lspinstall/css/vscode-css/css-language-features/server/dist/node/cssServerMain.js",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  less = {
    formatters = {
      {
        -- @usage can be prettier or prettierd
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "cssls",
      setup = {
        cmd = {
          "node",
          DATA_PATH .. "/lspinstall/css/vscode-css/css-language-features/server/dist/node/cssServerMain.js",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  d = {
    formatters = {
      {
        -- @usage can be dfmt
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "serve_d",
      setup = {
        cmd = { "serve-d" },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  dart = {
    formatters = {
      {
        -- @usage can be dart_format
        exe = "",
        args = {},
        stdin = true,
      },
    },
    linters = {},
    lsp = {
      provider = "dartls",
      setup = {
        cmd = {
          "dart",
          "/usr/lib/dart/bin/snapshots/analysis_server.dart.snapshot",
          "--lsp",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  docker = {
    formatters = {
      {
        exe = "",
        args = {},
      },
      -- @usage can be {"hadolint"}
    },
    linters = {},
    lsp = {
      provider = "dockerls",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/dockerfile/node_modules/.bin/docker-langserver",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  elixir = {
    formatters = {
      {
        -- @usage can be mix
        exe = "",
        args = {},
        stdin = true,
      },
    },
    linters = {},
    lsp = {
      provider = "elixirls",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/elixir/elixir-ls/language_server.sh",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  elm = {
    formatters = {
      {
        -- @usage can be elm_format
        exe = "",
        args = {},
        stdin = true,
      },
    },
    linters = {},
    lsp = {
      provider = "elmls",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/elm/node_modules/.bin/elm-language-server",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        -- init_options = {
        -- elmAnalyseTrigger = "change",
        -- elmFormatPath = DATA_PATH .. "/lspinstall/elm/node_modules/.bin/elm-format",
        -- elmPath = DATA_PATH .. "/lspinstall/elm/node_modules/.bin/",
        -- elmTestPath = DATA_PATH .. "/lspinstall/elm/node_modules/.bin/elm-test",
        -- },
      },
    },
  },
  erlang = {
    formatters = {
      {
        -- @usage can be erlfmt
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "erlangls",
      setup = {
        cmd = {
          "erlang_ls",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  emmet = { active = false },
  fish = {
    formatters = {
      {
        -- @usage can be fish_indent
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "",
      setup = {
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  go = {
    formatters = {
      {
        -- @usage can be gofmt or goimports or gofumpt
        exe = "",
        args = {},
        stdin = true,
      },
    },
    linters = {},
    lsp = {
      provider = "gopls",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/go/gopls",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  graphql = {
    formatters = { {
      exe = "",
      args = {},
    } },
    linters = {},
    lsp = {
      provider = "graphql",
      setup = {
        cmd = {
          "graphql-lsp",
          "server",
          "-m",
          "stream",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  haskell = {
    formatters = { {
      exe = "",
      args = {},
    } },
    linters = {},
    lsp = {
      provider = "hls",
      setup = {
        cmd = { DATA_PATH .. "/lspinstall/haskell/hls" },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  html = {
    formatters = {
      {
        -- @usage can be prettier or prettierd
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "html",
      setup = {
        cmd = {
          "node",
          DATA_PATH .. "/lspinstall/html/vscode-html/html-language-features/server/dist/node/htmlServerMain.js",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  java = {
    formatters = {
      {
        -- @usage can be clang_format or uncrustify
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "jdtls",
      setup = {
        cmd = { DATA_PATH .. "/lspinstall/java/jdtls.sh" },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  json = {
    formatters = {
      {
        -- @usage can be json_tool or prettier or prettierd
        exe = "",
        args = {},
        stdin = true,
      },
    },
    linters = {},
    lsp = {
      provider = "jsonls",
      setup = {
        cmd = {
          "node",
          DATA_PATH .. "/lspinstall/json/vscode-json/json-language-features/server/dist/node/jsonServerMain.js",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
        settings = {
          json = {
            schemas = schemas,
            --   = {
            --   {
            --     fileMatch = { "package.json" },
            --     url = "https://json.schemastore.org/package.json",
            --   },
            -- },
          },
        },
        commands = {
          Format = {
            function()
              vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
            end,
          },
        },
      },
    },
  },
  julia = {
    formatters = { {
      exe = "",
      args = {},
    } },
    linters = {},
    lsp = {
      provider = "julials",
      setup = {
        {
          "julia",
          "--startup-file=no",
          "--history-file=no",
          -- vim.fn.expand "~/.config/nvim/lua/lsp/julia/run.jl",
          CONFIG_PATH .. "/utils/julia/run.jl",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  kotlin = {
    formatters = { {
      exe = "",
      args = {},
    } },
    linters = {},
    lsp = {
      provider = "kotlin_language_server",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/kotlin/server/bin/kotlin-language-server",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        root_dir = function(fname)
          local util = require "lspconfig/util"

          local root_files = {
            "settings.gradle", -- Gradle (multi-project)
            "settings.gradle.kts", -- Gradle (multi-project)
            "build.xml", -- Ant
            "pom.xml", -- Maven
          }

          local fallback_root_files = {
            "build.gradle", -- Gradle
            "build.gradle.kts", -- Gradle
          }
          return util.root_pattern(unpack(root_files))(fname) or util.root_pattern(unpack(fallback_root_files))(fname)
        end,
      },
    },
  },
  lua = {
    formatters = {
      {
        -- @usage can be stylua or lua_format
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "sumneko_lua",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/lua/sumneko-lua-language-server",
          "-E",
          DATA_PATH .. "/lspinstall/lua/main.lua",
        },
        capabilities = common_capabilities,
        on_attach = common_on_attach,
        on_init = common_on_init,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
              -- Setup your lua path
              path = vim.split(package.path, ";"),
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim", "lvim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = {
                [vim.fn.expand "~/.local/share/lunarvim/lvim/lua"] = true,
                [vim.fn.expand "$VIMRUNTIME/lua"] = true,
                [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
              },
              maxPreload = 100000,
              preloadFileSize = 1000,
            },
          },
        },
      },
    },
  },
  nginx = {
    formatters = {
      {
        -- @usage can be nginx_beautifier
        exe = "",
        args = {
          provider = "",
          setup = {},
        },
      },
    },
    linters = {},
    lsp = {},
  },
  perl = {
    formatters = {
      {
        -- @usage can be perltidy
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "",
      setup = {},
    },
  },
  sql = {
    formatters = {
      {
        -- @usage can be sqlformat
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "sqls",
      setup = {
        cmd = { "sqls" },
      },
    },
  },
  php = {
    formatters = {
      {
        -- @usage can be phpcbf
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "intelephense",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/php/node_modules/.bin/intelephense",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        filetypes = { "php", "phtml" },
        settings = {
          intelephense = {
            environment = {
              phpVersion = "7.4",
            },
          },
        },
      },
    },
  },
  puppet = {
    formatters = { {
      exe = "",
      args = {},
    } },
    linters = {},
    lsp = {
      provider = "puppet",
      setup = {
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  javascript = {
    -- @usage can be prettier or prettier_d_slim or prettierd
    formatters = {
      {
        exe = "",
        args = {},
      },
    },
    -- @usage can be {"eslint"} or {"eslint_d"}
    linters = {},
    lsp = {
      provider = "tsserver",
      setup = {
        cmd = {
          -- TODO:
          DATA_PATH .. "/lspinstall/typescript/node_modules/.bin/typescript-language-server",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  javascriptreact = {
    formatters = {
      {
        -- @usage can be prettier or prettier_d_slim or prettierd
        exe = "",
        args = {},
      },
    },
    -- @usage can be {"eslint"} or {"eslint_d"}
    linters = {},
    lsp = {
      provider = "tsserver",
      setup = {
        cmd = {
          -- TODO:
          DATA_PATH .. "/lspinstall/typescript/node_modules/.bin/typescript-language-server",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  python = {
    formatters = {
      {
        -- @usage can be black or yapf or isort
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "pyright",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/python/node_modules/.bin/pyright-langserver",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  -- R -e 'install.packages("formatR",repos = "http://cran.us.r-project.org")'
  -- R -e 'install.packages("readr",repos = "http://cran.us.r-project.org")'
  r = {
    formatters = {
      {
        -- @usage can be format_r
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "r_language_server",
      setup = {
        cmd = {
          "R",
          "--slave",
          "-e",
          "languageserver::run()",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  ruby = {
    formatters = {
      {
        -- @usage can be rufo
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "solargraph",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/ruby/solargraph/solargraph",
          "stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
        filetypes = { "ruby" },
        init_options = {
          formatting = true,
        },
        root_dir = function(fname)
          local util = require("lspconfig").util
          return util.root_pattern("Gemfile", ".git")(fname)
        end,
        settings = {
          solargraph = {
            diagnostics = true,
          },
        },
      },
    },
  },
  rust = {
    formatters = {
      {
        -- @usage can be rustfmt
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "rust_analyzer",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/rust/rust-analyzer",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  scala = {
    formatters = {
      {
        -- @usage can be scalafmt
        exe = "",
        args = {},
      },
    },
    linters = { "" },
    lsp = {
      provider = "metals",
      setup = {
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  sh = {
    formatters = {
      {
        -- @usage can be shfmt
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "bashls",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/bash/node_modules/.bin/bash-language-server",
          "start",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  svelte = {
    formatters = { {
      exe = "",
      args = {},
    } },
    linters = {},
    lsp = {
      provider = "svelte",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/svelte/node_modules/.bin/svelteserver",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  swift = {
    formatters = {
      {
        -- @usage can be swiftformat
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "sourcekit",
      setup = {
        cmd = {
          "xcrun",
          "sourcekit-lsp",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  tailwindcss = {
    active = false,
    filetypes = {
      "html",
      "css",
      "scss",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
  },
  terraform = {
    formatters = {
      {
        -- @usage can be terraform_fmt
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "terraformls",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/terraform/terraform-ls",
          "serve",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  tex = {
    formatters = {
      {
        exe = "",
        args = {},
        stdin = false,
      },
      -- @usage can be chktex or vale
    },
    linters = {},
    lsp = {
      provider = "texlab",
      setup = {
        cmd = { DATA_PATH .. "/lspinstall/latex/texlab" },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  typescript = {
    formatters = {
      {
        -- @usage can be prettier or prettierd or prettier_d_slim
        exe = "",
        args = {},
      },
      -- @usage can be {"eslint"} or {"eslint_d"}
    },
    linters = {},
    lsp = {
      provider = "tsserver",
      setup = {
        cmd = {
          -- TODO:
          DATA_PATH .. "/lspinstall/typescript/node_modules/.bin/typescript-language-server",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  typescriptreact = {
    formatters = {
      {
        -- @usage can be prettier or prettierd or prettier_d_slim
        exe = "",
        args = {},
      },
    },
    -- @usage can be {"eslint"} or {"eslint_d"}
    linters = {},
    lsp = {
      provider = "tsserver",
      setup = {
        cmd = {
          -- TODO:
          DATA_PATH .. "/lspinstall/typescript/node_modules/.bin/typescript-language-server",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  vim = {
    formatters = {
      {
        exe = "",
        args = {},
      },
    },
    -- @usage can be {"vint"}
    linters = { "" },
    lsp = {
      provider = "vimls",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/vim/node_modules/.bin/vim-language-server",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  vue = {
    formatters = {
      {
        -- @usage can be prettier or prettierd or prettier_d_slim
        exe = "",
        args = {},
      },
    },
    -- @usage can be {"eslint"} or {"eslint_d"}
    linters = {},
    lsp = {
      provider = "vuels",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/vue/node_modules/.bin/vls",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  yaml = {
    formatters = {
      {
        -- @usage can be prettier or prettierd
        exe = "",
        args = {},
      },
    },
    linters = {},
    lsp = {
      provider = "yamlls",
      setup = {
        cmd = {
          DATA_PATH .. "/lspinstall/yaml/node_modules/.bin/yaml-language-server",
          "--stdio",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  zig = {
    formatters = { {
      exe = "",
      args = {},
      stdin = false,
    } },
    linters = {},
    lsp = {
      provider = "zls",
      setup = {
        cmd = {
          "zls",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  gdscript = {
    formatters = {},
    linters = {},
    lsp = {
      provider = "gdscript",
      setup = {
        cmd = {
          "nc",
          "localhost",
          "6008",
        },
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
  ps1 = {
    formatters = {},
    linters = {},
    lsp = {
      provider = "powershell_es",
      setup = {
        bundle_path = "",
        on_attach = common_on_attach,
        on_init = common_on_init,
        capabilities = common_capabilities,
      },
    },
  },
}

require("keymappings").config()
require("core.which-key").config()
require "core.status_colors"
require("core.gitsigns").config()
require("core.compe").config()
require("core.dashboard").config()
require("core.dap").config()
require("core.terminal").config()
require("core.telescope").config()
require("core.treesitter").config()
require("core.nvimtree").config()
require("core.rooter").config()
require("core.bufferline").config()

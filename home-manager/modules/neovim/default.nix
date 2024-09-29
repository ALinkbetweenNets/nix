{ lib, pkgs, inputs, nixvim, ... }:
with lib; {
  # programs.neovim = {
  #   enable = true;
  #   coc.enable = true;
  #   plugins = with pkgs.vimPlugins; [ yankring vim-nix ];
  # };
  programs.nixvim = {
    enable = true;
    enableMan = true;
    viAlias = true;
    vimAlias = true;
    # let bindings
    globals = {
      mapleader = " "; # Sets the leader key to space
      maplocalleader = " "; # Sets the leader key to space
      # g:netrw_browsex_viewer= "xdg-open";
    };
    options = {
      # completeopt = [ "menu" "menuone" "noselect" ];
      autoindent = true;
      autoread = true;
      clipboard = "unnamedplus";
      cursorline = false;
      expandtab = true;
      ignorecase = true;
      incsearch = true;
      list = false;
      modeline = true; # Tags such as 'vim:ft=sh'
      modelines = 100; # Sets the type of modelines
      mouse = "a";
      mousemoveevent = true;
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers
      scrolloff = 3;
      shiftwidth = 2; # Tab width should be 2
      smartcase = true;
      softtabstop = 0;
      spelllang = "en_us";
      tabstop = 2;
      termguicolors = true;
      undofile = true; # Automatically save and restore undo history
      updatetime = 100; # Faster completion
    };
    keymaps = [{
      mode = "t";
      key = "<Esc>";
      options.silent = true;
      action = "<C-><C-n>";
    }];
    plugins = {
      lightline.enable = true;

      #  comment-nvim = {
      #    enable = true;
      #  };
      #  trouble = {
      #    enable = true;
      #  };
      #  bufferline = {
      #    enable = false;
      #    alwaysShowBufferline = false;
      #  };
      lsp = {
        enable = true;
        #    keymaps = {
        #      silent = true;
        #      diagnostic = {
        #        # Navigate in diagnostics
        #        "[d" = "goto_prev";
        #        "]d" = "goto_next";
        #        "<leader>d" = "open_float";
        #      };
        #      lspBuf = {
        #        gd = "definition";
        #        gD = "references";
        #        gt = "type_definition";
        #        gi = "implementation";
        #        K = "hover";
        #        "<leader>r" = "rename";
        #      };
        #    };
        #    enabledServers = [
        #      "bashls"
        #      "clangd"
        #      "nil_ls"
        #      "lua_ls"
        #      "eslint"
        #      "html"
        #      "jsonls"
        #      "cssls"
        #      "zls"
        #    ];
      };
      #  # NOTE: This plugin handles everything for rust.
      #  # rust-tools = {
      #  #   enable = true;
      #  # };
      #  nvim-cmp = {
      #    enable = true;
      #    snippet.expand = "luasnip";
      #    mapping = {
      #      "<C-u>" = "cmp.mapping.scroll_docs(-3)";
      #      "<C-d>" = "cmp.mapping.scroll_docs(3)";
      #      "<C-Space>" = "cmp.mapping.complete()";
      #      "<tab>" = "cmp.mapping.close()";
      #      "<c-n>" = {
      #        modes = [ "i" "s" ];
      #        action = "cmp.mapping.select_next_item()";
      #      };
      #      "<c-p>" = {
      #        modes = [ "i" "s" ];
      #        action = "cmp.mapping.select_prev_item()";
      #      };
      #      "<CR>" = "cmp.mapping.confirm({ select = true })";
      #    };
      #    sources = [
      #      { name = "path"; }
      #      { name = "nvim_lsp"; }
      #      # { name = "cmp_tabnine"; }
      #      { name = "luasnip"; }
      #      {
      #        name = "buffer";
      #        # Words from other open buffers can also be suggested.
      #        option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
      #      }
      #      { name = "neorg"; }
      #    ];
      #  };
      #  luasnip = {
      #    enable = true;
      #  };
      #  lspkind = {
      #    enable = true;
      #    cmp = {
      #      enable = true;
      #      menu = {
      #        nvim_lsp = "[LSP]";
      #        nvim_lua = "[api]";
      #        path = "[path]";
      #        luasnip = "[snip]";
      #        buffer = "[buf]";
      #        neorg = "[norg]";
      #        # cmp_tabnine = "[t9]";
      #      };
      #    };
      #  };
      #  # files & dir navigation
      #  oil = {
      #    enable = true;
      #    deleteToTrash = false; # TODO: Configure trash
      #    keymaps = {
      #      "<C-s>" = "false";
      #      "<C-h>" = "false";
      #      "xv" = "actions.select_vsplit";
      #      "xs" = "actions.select_split";
      #    };
      #    columns = {
      #      icon.enable = true;
      #      permissions.enable = true;
      #      type.enable = true;
      #    };
      #  };
      #  # buffer navigation
      #  flash = {
      #    enable = true; # mapping
      #  };
      #  # syntax
      #  treesitter = {
      #    enable = true;
      #    nixvimInjections = true;
      #    folding = true;
      #    indent = true;
      #  };
      #  markdown-preview = {
      #    enable = true;
      #    # theme = "dark";
      #  };
      #  treesitter-refactor = {
      #    enable = true;
      #    highlightDefinitions.enable = true;
      #  };
      #  # code folding
      #  # nvim-ufo = {
      #  #   enable = true;
      #  # };
      #  gitsigns = {
      #    enable = true;
      #  };
      #  nvim-autopairs.enable = true;
      #  nvim-colorizer = {
      #    enable = true;
      #    userDefaultOptions.names = false;
      #  };
      #  # highlight all occurences of of WUTC(word under the cursor)
      #  illuminate = {
      #    enable = true;
      #  };
      #  # keymap previewer helper
      #  which-key = {
      #    enable = true;
      #  };
      #  /*
      #     Easy to spot marker comments
      #  hack: wEiRd CoDe
      #  warn: A warning
      #  perf: Fully optimized(Performant)
      #  note: A note
      #  test: A test
      #  fix: Needs fixing
      #  */
      #  todo-comments = {
      #    enable = true;
      #  };
      #  conform-nvim = {
      #    enable = true;
      #    formatOnSave = {
      #      timeoutMs = 500;
      #      lspFallback = true;
      #    };
      #    formattersByFt = {
      #      javascript = [ "prettier" ];
      #      nix = [ "alejandra" ];
      #      # rust = [ "rustfmt" ];
      #    };
      #  };
      #  # Tim Pope's surround plugin
      #  surround = {
      #    enable = true;
      #  };
      #  # Fuzzy navigation menu for files, buffers & more
      #  telescope = {
      #    enable = true;
      #    keymaps = {
      #      # Find files using Telescope command-line sugar.
      #      "<c-s>f" = "find_files";
      #      "<c-s>g" = "live_grep";
      #      "<c-s>b" = "current_buffer_fuzzy_find";
      #      "<c-s>m" = "marks";
      #      "<c-s>h" = "help_tags";
      #      "<c-s>d" = "diagnostics";
      #      "<c-s>D" = "lsp_definitions";
      #      "<c-s>o" = "oldfiles";
      #      "<c-s>c" = "commands";
      #      "<c-s>C" = "command_history";
      #      "<c-s>q" = "quickfix";
      #      "<c-s>r" = "registers";
      #      "<c-s>v" = "vim_options";
      #      "<c-s>x" = "spell_suggest";
      #      "<c-s>lr" = "lsp_references";
      #      "<c-s>ls" = "lsp_document_symbols";
      #      "<c-s>ld" = "diagnostics";
      #      "<c-s>lD" = "lsp_definitions";
      #      "<c-s>lt" = "lsp_type_definitions";
      #      "<leader><space>" = "buffers";
      #      # TODO: FZF like bindings
      #      # "<C-p>" = "git_files";
      #      # "<leader>p" = "oldfiles";
      #      # "<C-f>" = "live_grep";
      #    };
      #    extraOptions.pickers.buffers = {
      #      show_all_buffers = "true";
      #      theme = "dropdown";
      #      mappings = {
      #        i = {
      #          "<c-s>" = "delete_buffer";
      #        };
      #        n = {
      #          "dd" = "delete_buffer";
      #          "x" = "delete_buffer";
      #        };
      #      };
      #    };
      #    keymapsSilent = true;
      #    defaults = {
      #      file_ignore_patterns = [
      #        "^.git/"
      #        "^.mypy_cache/"
      #        "^__pycache__/"
      #        "^output/"
      #        "^data/"
      #        "%.ipynb"
      #      ];
      #      set_env.COLORTERM = "truecolor";
      #    };
      #  }; # Faster file navigation
      #  harpoon = {
      #    enable = false; # TODO: Configure later
      #    enableTelescope = true;
      #  };
      #  # Navigate your vim undo history
      #  undotree = {
      #    enable = false;
      #  };
      #  # Indentation guides
      #  indent-blankline = {
      #    # TODO: Autostart
      #    enable = true;
      #  };
      #  nix = {
      #    enable = true;
      #  };
      #  nix-develop = {
      #    enable = true;
      #  };
      #  # Discord rich presence
      #  # presence-nvim = {
      #  #   # TODO: Configure later
      #  #   enable = false;
      #  #   neovimImageText = "I'm still breathing! Are you?";
      #  #   clientId = "1125469005931630675";
      #  #   logLevel = "debug";
      #  # };

    };
    # autoCmd = [
    #   # Vertically center document when entering insert mode
    #   # {
    #   #   event = "InsertEnter";
    #   #   command = "norm zz";
    #   # }      # Remove trailing whitespace on save
    #   {
    #     event = "BufWrite";
    #     command = "%s/\\s\\+$//e";
    #   } # Open help in a vertical split
    #   # {
    #   #   event = "FileType";
    #   #   pattern = "help";
    #   #   command = "wincmd L";
    #   # }      # Set indentation to 2 spaces for nix files
    #   {
    #     event = "FileType";
    #     pattern = "nix";
    #     command = "setlocal tabstop=2 shiftwidth=2";
    #   } # {
    #   #   event = "FileType";
    #   #   pattern = "oil";
    #   #   callback = ''
    #   #     function()
    #   #       vim.keymap.set("n", "<leader>o", ":bd<cr>", { desc = "close oil", buffer = true })
    #   #     end
    #   #   '';
    #   # }      # Enable spellcheck for some filetypes
    #   {
    #     event = "FileType";
    #     pattern = [ "tex" "latex" "markdown" "norg" "text" ];
    #     command = "setlocal spell spelllang=en";
    #   }
    # ];
  };
  home.packages = with pkgs; [
    lua-language-server
    vscode-langservers-extracted
    nil
    zls
  ];
}

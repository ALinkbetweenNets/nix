{ lib, pkgs, inputs, nixvim, config, ... }:
with lib; {
  # programs.neovim = {
  #   enable = true;
  #   coc.enable = true;
  #   plugins = with pkgs.vimPlugins; [ yankring vim-nix ];
  # };
  config = {
    programs.helix = {
      enable = true;
      settings = {
        theme = "base16_transparent";
        editor.lsp.display-messages = true;
        editor.cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
      languages = {
        language = [{
          name = "nix";
          auto-format = true;
          formatter.command =
            "${pkgs.nixfmt-classic}/bin/nixfmt";
        }];
      };
    };
    programs.nvf = {
      enable = true;
      # your settings need to go into the settings attribute set
      # most settings are documented in the appendix
      settings.vim = {
        spellcheck.enable = true;
        viAlias = false;
        vimAlias = true;
        lsp = {
          enable = true;
          formatOnSave = false;
          lightbulb.enable = true;
          # lsplines.enable = true;
          lspsaga.enable = true;
          lspSignature.enable = true;
          nvim-docs-view.enable = true;
          otter-nvim.enable = true;
          trouble.enable = true;
        };
        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };
        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          nix.enable = true;
          python.enable = true;
          markdown.enable = true;
          html.enable = true;
          css.enable = true;
          sql.enable = true;
          bash.enable = true;
          clang = {
            enable = true;
            lsp.server = "clangd";
          };
        };
        visuals = {
          nvim-web-devicons.enable = true;
          nvim-scrollbar.enable = true;
          cinnamon-nvim.enable = true;
          cellular-automaton.enable = true;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;
          indent-blankline.enable = true;
          nvim-cursorline = {
            enable = true;
            setupOpts.line_timeout = 0;
          };
        };
        statusline = {
          lualine = {
            enable = true;
            theme = "auto";
          };
        };
        theme = {
          enable = true;
          #name = "darker";
          style = "darker";
          transparent = true;
        };
        filetree = {
          nvimTree = {
            enable = true;
            openOnSetup = false;
          };
        };
        tabline = { nvimBufferline.enable = true; };
        treesitter.context.enable = true;
        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };
        telescope.enable = true;
        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = true; # throws an annoying debug message
        };
        minimap = {
          minimap-vim.enable = true;
          codewindow.enable =
            true; # lighter, faster, and uses lua for configuration
        };
        dashboard = {
          dashboard-nvim.enable = true;
          alpha.enable = true;
        };
        notify = { nvim-notify.enable = true; };
        projects = { project-nvim.enable = true; };
        utility = {
          ccc.enable = true;
          vim-wakatime.enable = true;
          icon-picker.enable = true;
          surround.enable = true;
          diffview-nvim.enable = true;
          motion = {
            hop.enable = true;
            leap.enable = true;
          };
          images = { image-nvim.enable = false; }; # Does not work in Konsole
        };
        notes = {
          #obsidian.enable =
          #  true; # FIXME: neovim fails to build if obsidian is enabled
          #obsidian.setupOpts.workspaces = [
          #  {
          #    name = "obsidian";
          #    path = "/home/l/obsidian";
          #  }
          #];

          orgmode.enable = false;
          mind-nvim.enable = true;
          todo-comments.enable = true;
        };
        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };
        ui = {
          borders.enable = true;
          noice.enable = true;
          colorizer.enable = false;
          modes-nvim.enable = false; # the theme looks terrible with catppuccin
          illuminate.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
          };
          smartcolumn = {
            enable = false;
            setupOpts.custom_colorcolumn = {
              # this is a freeform module, it's `buftype = int;` for configuring column position
              nix = "110";
              ruby = "120";
              java = "130";
              go = [ "90" "130" ];
            };
          };
          fastaction.enable = true;
        };
        assistant = {
          chatgpt.enable = false;
          copilot = {
            enable = false;
            cmp.enable = true;
          };
        };
        session = { nvim-session-manager.enable = true; };
        gestures = { gesture-nvim.enable = true; };
        comments = { comment-nvim.enable = true; };
        presence = { neocord.enable = false; };
      };
    };
  };
}

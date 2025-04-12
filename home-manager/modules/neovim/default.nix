{ lib, pkgs, inputs, nixvim, config, ... }:
with lib; {
  # programs.neovim = {
  #   enable = true;
  #   coc.enable = true;
  #   plugins = with pkgs.vimPlugins; [ yankring vim-nix ];
  # };
  config = {
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
          lsplines.enable = true;
          lspsaga.enable = false;
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
          enableLSP = true;
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
          cellular-automaton.enable = false;
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
        # filetree = { nvimTree = { enable = true; }; };
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
          gitsigns.codeActions.enable =
            false; # throws an annoying debug message
        };
        minimap = {
          minimap-vim.enable = false;
          codewindow.enable =
            true; # lighter, faster, and uses lua for configuration
        };
        dashboard = {
          dashboard-nvim.enable = false;
          alpha.enable = true;
        };
        notify = { nvim-notify.enable = true; };
        projects = { project-nvim.enable = true; };
        utility = {
          ccc.enable = false;
          vim-wakatime.enable = false;
          icon-picker.enable = true;
          surround.enable = true;
          diffview-nvim.enable = true;
          motion = {
            hop.enable = true;
            leap.enable = true;
          };
          images = { image-nvim.enable = false; };
        };
        notes = {
          obsidian.enable =
            false; # FIXME: neovim fails to build if obsidian is enabled
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
          colorizer.enable = true;
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
        session = { nvim-session-manager.enable = false; };
        gestures = { gesture-nvim.enable = false; };
        comments = { comment-nvim.enable = true; };
        presence = { neocord.enable = false; };
      };
    };
  };
}

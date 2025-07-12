{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.code;
in {
  options.link.code.enable = mkEnableOption "activate vscodium";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gdb
      nil
      nixd
      nixfmt-classic
      vscode-langservers-extracted
    ];
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      # package = pkgs.vscode.fhsWithPackages (ps: with ps; [ rustup zlib openssl.dev pkg-config  ]);
      profiles.default.enableUpdateCheck = false;
      profiles.default.enableExtensionUpdateCheck = true;
      profiles.default.extensions = with pkgs.vscode-extensions;
        [
          continue.continue # ollama
          myriad-dreamin.tinymist # typst
          #b4dm4n.vscode-nixpkgs-fmt
          #vscodevim.vim
          arrterian.nix-env-selector
          # dracula-theme.theme-dracula
          christian-kohler.path-intellisense
          dbaeumer.vscode-eslint
          christian-kohler.npm-intellisense
          yoavbls.pretty-ts-errors
          bradlc.vscode-tailwindcss
          eamodio.gitlens
          esbenp.prettier-vscode
          firefox-devtools.vscode-firefox-debug
          github.copilot
          github.vscode-github-actions
          github.vscode-pull-request-github
          gitlab.gitlab-workflow
          gruntfuggly.todo-tree
          jnoortheen.nix-ide
          mkhl.direnv
          myriad-dreamin.tinymist
          ms-vscode-remote.remote-ssh
          redhat.vscode-xml
          redhat.vscode-yaml
          streetsidesoftware.code-spell-checker
          usernamehw.errorlens
          vadimcn.vscode-lldb
          yzhang.markdown-all-in-one
          # pokey.talon
          # pokey.cursorless
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "vscode-pets";
          publisher = "tonybaloney";
          version = "1.25.1";
          sha256 =
            "6acdded8bcca052b221acfd4188674e97a9b2e1dfb8ab0d4682cec96a2131094";
        }];
      profiles.default.userSettings = {
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };
        "[nix]" = { "editor.defaultFormatter" = "jnoortheen.nix-ide"; };
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        # "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nil" = {
            "diagnostics" = { "ignored" = [ "unused_binding" "unused_with" ]; };
            "formatting" = { "command" = [ "nixfmt" ]; };
          };
          # "nixd" = {
          #   # "eval" = { };
          #   "formatting" = {
          #     "command" = [ "nixfmt ." ];
          #   };
          #   "options" = {
          #     "nixos" = {
          #       "expr" = "(builtins.getFlake .#nixosConfigurations.fn.options";
          #     };
          #     "home-manager" = {
          #       "expr" = "(builtins.getFlake.#homeConfigurations.laptop.options";
          #     };
          #     # "target" = {
          #     #   "args" = [ ];
          #     #   "installable" = "(builtins.getFlake \"\${workspaceFolder}\")#nixosConfigurations.<name>.options";
          #     # };
          #   };
          # };
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
        "continue.telemetryEnabled" = false;
        "cSpell.userWords" = [ "Linkbetween" ];
        "diffEditor.codeLens" = true;
        "diffEditor.diffAlgorithm" = "advanced";
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.cursorBlinking" = "expand";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.cursorSurroundingLinesStyle" = "all";
        "editor.defaultColorDecorators" = "auto";
        "editor.find.autoFindInSelection" = "multiline";
        "editor.fontFamily" = "'FiraCode Nerd Font'";
        "editor.fontLigatures" = true;
        "editor.fontSize" = 12;
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;
        "editor.inlineSuggest.enabled" = true;
        "editor.linkedEditing" = true;
        "editor.minimap.maxColumn" = 160;
        "editor.mouseWheelZoom" = true;
        "editor.renderWhitespace" = "all";
        "editor.smoothScrolling" = true;
        "editor.stickyTabStops" = true;
        "editor.suggest.preview" = true;
        "editor.tabCompletion" = "on";
        "editor.tabSize" = 2;
        "editor.wordWrap" = "on";
        "editor.wordWrapColumn" = 160;
        "explorer.incrementalNaming" = "smart";
        "extensions.autoCheckUpdates" = false;
        "extensions.autoUpdates" = false;
        "files.autoGuessEncoding" = true;
        "files.autoSave" = "afterDelay";
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "files.trimTrailingWhitespace" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "gitlens.views.contributors.showStatistics" = true;
        "latex-workshop.formatting.latex" = "tex-fmt";
        "latex-workshop.view.pdf.invert" = 1;
        "latex-workshop.view.pdf.invertMode.enabled" = "auto";
        "ltex.additionalRules.enablePickyRules" = true;
        "ltex.language" = "de-DE";
        "markdown.extension.completion.enabled" = true;
        "prettier.printWidth" = 160;
        "problems.showCurrentInStatus" = true;
        "redhat.telemetry.enabled" = false;
        "scm.alwaysShowActions" = true;
        "scm.alwaysShowRepositories" = true;
        "search.experimental.notebookSearch" = true;
        "search.smartCase" = true;
        "terminal.integrated.enableImages" = true;
        "terminal.integrated.enableVisualBell" = true;
        "terminal.integrated.mouseWheelZoom" = true;
        "vscode-pets.petColor" = "white";
        # "vscode-pets.position" = "panel";
        "vscode-pets.throwBallWithMouse" = true;
        "workbench.editor.highlightModifiedTabs" = true;
        "workbench.editor.limit.enabled" = true;
        "workbench.list.smoothScrolling" = true;
        "zenMode.showTabs" = "none";
        # "vscode-pets.theme" = "castle";
        # "window.titleBarStyle" = "native";
        # "workbench.colorTheme" = "Dracula";
      };
      profiles.default.globalSnippets = {
        fixme = {
          body = [ "$LINE_COMMENT FIXME: $0" ];
          description = "Insert a FIXME remark";
          prefix = [ "fixme" ];
        };
      };
      profiles.default.keybindings = [
        {
          key = "ctrl+alt+f";
          command = "leap.search";
        }
        {
          key = "ctrl+c";
          command = "editor.action.clipboardCopyAction";
          when = "textInputFocus";
        }
        {
          "key" = "ctrl+shift+i";
          "command" = "-continue.focusEditWithoutClear";
        }
        {
          key = "ctrl+[Backquote]";
          command = "terminal.focus";
        }
        # {
        #   key = "ctrl+shift+d";
        #   command = "workbench.action.terminal.sendSequence";
        #   args = {
        #     text = ''
        #       cd /home/l/nix;nix run .\#lollypops -- vn
        #     '';
        #   };
        # }
      ];
    };
  };
}

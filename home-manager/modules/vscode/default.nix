{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.code;
in {
  options.link.code.enable = mkEnableOption "activate vscodium";
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      # package = pkgs.vscodium;
      # package = pkgs.vscode.fhsWithPackages (ps: with ps; [ rustup zlib openssl.dev pkg-config  ]);
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        #b4dm4n.vscode-nixpkgs-fmt
        #vscodevim.vim
        arrterian.nix-env-selector
        # dracula-theme.theme-dracula
        eamodio.gitlens
        esbenp.prettier-vscode
        firefox-devtools.vscode-firefox-debug
        github.copilot
        github.vscode-pull-request-github
        gruntfuggly.todo-tree
        jnoortheen.nix-ide
        mkhl.direnv
        ms-vscode-remote.remote-ssh
        redhat.vscode-yaml
        streetsidesoftware.code-spell-checker
        #tamasfe.even-better-toml
        usernamehw.errorlens
        vadimcn.vscode-lldb
        yzhang.markdown-all-in-one
        # pokey.talon
        # pokey.cursorless
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-pets";
          publisher = "tonybaloney";
          version = "1.25.1";
          sha256 = "6acdded8bcca052b221acfd4188674e97a9b2e1dfb8ab0d4682cec96a2131094";
        }
      ];
      userSettings = {
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
        };
        "nix" = {
          "enableLanguageServer" = true;
          "serverPath" = "${pkgs.nil}/bin/nil";
          "serverSettings" = {
            "nil" = {
              "formatting" = {
                "command" = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
              };
            };
          };
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
        "cSpell.userWords" = [
          "Linkbetween"
        ];
        "diffEditor.codeLens" = true;
        "diffEditor.diffAlgorithm" = "advanced";
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.cursorBlinking" = "expand";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.cursorSurroundingLinesStyle" = "all";
        "editor.defaultColorDecorators" = true;
        "editor.find.autoFindInSelection" = "multiline";
        "editor.fontFamily" = "'Fira Code', 'Hack NF', 'Droid Sans Mono', 'monospace', monospace";
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
        "editor.wordWrap" = "bounded";
        "editor.wordWrapColumn" = 160;
        "explorer.incrementalNaming" = "smart";
        "files.autoGuessEncoding" = true;
        "files.autoSave" = "afterDelay";
        "files.insertFinalNewline" = true;
        "files.trimFinalNewlines" = true;
        "files.trimTrailingWhitespace" = true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "prettier.printWidth" = 160;
        "problems.showCurrentInStatus" = true;
        "redhat.telemetry.enabled" = false;
        "scm.alwaysShowActions" = true;
        "scm.alwaysShowRepositories" = true;
        "search.experimental.notebookSearch" = true;
        "search.smartCase" = true;
        "workbench.editor.highlightModifiedTabs" = true;
        "workbench.editor.limit.enabled" = true;
        "workbench.list.smoothScrolling" = true;
        # "window.titleBarStyle" = "native";
        "vscode-pets.petColor" = "white";
        "vscode-pets.position" = "panel";
        # "vscode-pets.theme" = "castle";
        "vscode-pets.throwBallWithMouse" = true;
        # "workbench.colorTheme" = "Dracula";
        "latex-workshop.view.pdf.invertMode.enabled" = "auto";
        "latex-workshop.view.pdf.invert" = 1;
        "ltex.language" = "de-DE";
        "ltex.additionalRules.enablePickyRules" = true;
        "zenMode.showTabs" = "none";
      };
      globalSnippets = {
        fixme = {
          body = [ "$LINE_COMMENT FIXME: $0" ];
          description = "Insert a FIXME remark";
          prefix = [ "fixme" ];
        };
      };
      keybindings = [
        {
          key = "ctrl+c";
          command = "editor.action.clipboardCopyAction";
          when = "textInputFocus";
        }
        {
          key = "ctrl+[Backquote]";
          command = "terminal.focus";
        }
        {
          key = "ctrl+shift+d";
          command = "workbench.action.terminal.sendSequence";
          args = {
            text = "cd /home/l/nix;nix run .\\#lollypops -- vn\n";
          };
        }
      ];
    };
  };
}

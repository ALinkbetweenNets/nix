{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let cfg = config.link.code;
in {
  options.link.code.enable = mkEnableOption "activate vscodium";
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions; [
        arrterian.nix-env-selector
        b4dm4n.vscode-nixpkgs-fmt
        dracula-theme.theme-dracula
        eamodio.gitlens
        esbenp.prettier-vscode
        firefox-devtools.vscode-firefox-debug
        gruntfuggly.todo-tree
        jnoortheen.nix-ide
        ms-python.python
        ms-toolsai.jupyter
        ms-vscode-remote.remote-ssh
        streetsidesoftware.code-spell-checker
        tamasfe.even-better-toml
        usernamehw.errorlens
        vadimcn.vscode-lldb
        #vscodevim.vim
        yzhang.markdown-all-in-one
      ];
      userSettings = {
        "workbench.colorTheme" = "Dracula";
        "nix.enableLanguageServer" = "true";
        "nix.serverPath" = "${pkgs.nil}/bin/nil";
        "[nix]" = { "editor.defaultFormatter" = "B4dM4n.nixpkgs-fmt"; };
        "editor.tabSize" = "2";
        "editor.renderWhitespace" = "all";
        "editor.wordWrap" = "bounded";
        "editor.defaultColorDecorators" = "true";
        "git.confirmSync" = "false";
        "git.autofetch" = "true";
        "git.enableSmartCommit" = "true";
        "files.autoSave" = "afterDelay";
        "diffEditor.ignoreTrimWhitespace" = "false";
        "window.zoomLevel" = "-2";
        "editor.linkedEditing" = "true";
        "editor.mouseWheelZoom" = "true";
        "editor.smoothScrolling" = "true";
        "editor.tabCompletion" = "on";
        "editor.stickyTabStops" = "true";
        "editor.cursorBlinking" = "expand";
        "editor.cursorSmoothCaretAnimation" = "on";
        "editor.cursorSurroundingLinesStyle" = "all";
        "editor.find.autoFindInSelection" = "multiline";
        "editor.formatOnPaste" = "true";
        "editor.formatOnSave" = "true";
        "editor.formatOnType" = "true";
        "diffEditor.codeLens" = "true";
        "diffEditor.diffAlgorithm" = "advanced";
        "editor.suggest.preview" = "true";
        "files.autoGuessEncoding" = "true";
        "files.insertFinalNewline" = "true";
        "files.trimFinalNewlines" = "true";
        "files.trimTrailingWhitespace" = "true";
        "workbench.list.smoothScrolling" = "true";
        "workbench.editor.highlightModifiedTabs" = "true";
        "workbench.editor.limit.enabled" = "true";
        "explorer.incrementalNaming" = "smart";
        "search.experimental.notebookSearch" = "true";
        "search.smartCase" = "true";
        "scm.alwaysShowActions" = "true";
        "scm.alwaysShowRepositories" = "true";
        "problems.showCurrentInStatus" = "true";
      };
      globalSnippets = {
        fixme = {
          body = [ "$LINE_COMMENT FIXME: $0" ];
          description = "Insert a FIXME remark";
          prefix = [ "fixme" ];
        };
      };
      keybindings = [{
        key = "ctrl+c";
        command = "editor.action.clipboardCopyAction";
        when = "textInputFocus";
      }];
    };
  };

}

{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = [ ./desktop.nix ];
  config = {
    link.office.enable = true;
    link.pentesting.enable = true;
    link.latex.enable = true;
    link.gaming.enable = true;
    link.python.enable = true;
    services.kdeconnect = {
      enable = true;
      indicator = false;
    };
    home.packages = with pkgs; [
      alacritty
      # theming
      beauty-line-icon-theme
      dracula-theme
      # VMs
      virt-manager
      spice
      spice-vdagent
      # ISO stuff
      popsicle # USB Flasher
      ventoy-full
      # Misc
      #gsettings-desktop-schemas # required for some apps like jami
      # Editor
      logseq
      semantik # mind mapping
      # File Sync
      nextcloud-client
      seafile-client
      # Messenger
      signal-desktop
      telegram-desktop
      discord
      qtox
      # Utils
      mermaid-cli
      pomodoro
      links2 # TUI Browser
      screen-message
      vhs # generating terminal GIFs with code
      surfraw # TUI search engine interface
      translate-shell
      ffmpeg_6
      apg # generate passwords
      # Multimedia
      obs-studio
      obs-studio-plugins.obs-backgroundremoval
      brave # backup browser
      ytfzf
      youtube-tui
      catimg
      # Silly BS
      figlet # Fancytext
      uwuify
      # Privacy
      monero-gui

    ];
  };
}

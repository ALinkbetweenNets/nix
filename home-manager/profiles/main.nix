{ lib, pkgs, ... }:
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
      # Desktop monitor settings change
      ddcui
      ddcutil
      alacritty
      # theming
      beauty-line-icon-theme
      # dracula-theme
      # VMs
      virt-manager
      spice
      spice-vdagent
      # ISO stuff
      popsicle # USB Flasher
      ventoy-full
      nixos-anywhere
      # Misc
      #gsettings-desktop-schemas # required for some apps like jami
      # Editor
      # logseq
      semantik # mind mapping
      # File Sync
      nextcloud-client
      seafile-client
      # Messenger
      signal-desktop
      telegram-desktop
      discord
      qtox
      element-desktop
      # Utils
      mermaid-cli
      pomodoro
      links2 # TUI Browser
      screen-message
      vhs # generating terminal GIFs with code
      surfraw # TUI search engine interface
      translate-shell
      ffmpeg_6
      # Multimedia
      obs-studio
      obs-studio-plugins.obs-backgroundremoval
      imagemagick
      brave # backup browser
      ytfzf
      ani-cli
      youtube-tui
      catimg
      jellyfin-mpv-shim
      # Silly BS
      figlet # Fancytext
      uwuify
      # Privacy
      monero-gui
    ];
  };
}

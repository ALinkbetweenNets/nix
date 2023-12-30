{ lib, pkgs, ... }:
with lib; {
  imports = [ ./desktop.nix ];
  config = {
    link = {
      office.enable = true;
      pentesting.enable = true;
      latex.enable = true;
      gaming.enable = true;
      python.enable = true;
      # beancount.enable = true;
    };
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
      (import
        (builtins.fetchTarball {
          url = "https://github.com/nixos/nixpkgs/archive/9957cd48326fe8dbd52fdc50dd2502307f188b0d.tar.gz";
          sha256 = "sha256:1l2hq1n1jl2l64fdcpq3jrfphaz10sd1cpsax3xdya0xgsncgcsi";
        })
        { system = "${pkgs.system}"; }).popsicle # USB Flasher
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
      vial
      via
      qmk
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
      # youtube-tui
      ytui-music
      yewtube
      catimg
      jellyfin-mpv-shim
      digikam # photo library
      # Silly BS
      figlet # Fancytext
      uwuify
      # Privacy
      monero-gui
      bonn-mensa
      mediainfo # audio and video information
      tradingview
    ];
  };
}

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
      ansible.enable = true;
      # beancount.enable = true;
    };
    services.kdeconnect = {
      enable = true;
      indicator = false;
    };
    home.packages = with pkgs; [
      ltex-ls # for vscode spell checking using languagetool
      piper-tts # text to speech synthesizer with models (download https://huggingface.co/rhasspy/piper-voices/tree/v1.0.0/en/en_US/lessac/high onnx and json to Downloads folder)
      gnome.gnome-disk-utility
      gparted
      vagrant # quick tmp vm creation
      restic
      hugo # static site generator
      ghosttohugo
      ## Desktop monitor settings change
      ddcui
      ddcutil
      alacritty
      ## theming
      beauty-line-icon-theme
      # dracula-theme
      ## VMs
      virt-manager
      spice
      spice-vdagent
      ## ISO stuff
      (import
        (builtins.fetchTarball {
          url = "https://github.com/nixos/nixpkgs/archive/9957cd48326fe8dbd52fdc50dd2502307f188b0d.tar.gz";
          sha256 = "sha256:1l2hq1n1jl2l64fdcpq3jrfphaz10sd1cpsax3xdya0xgsncgcsi";
        })
        { system = "${pkgs.system}"; }).popsicle # USB Flasher
      # popsicle
      ## FS
      # nixos-anywhere # use nix-shell
      # ventoy-full # use nix-shell
      # gsettings-desktop-schemas # required for some apps like jami
      ## File Sync
      nextcloud-client
      seafile-client
      ## Editor
      mermaid-cli
      # logseq
      # anytype
      # semantik # mind mapping
      ## Messenger
      signal-desktop
      telegram-desktop
      discord
      qtox
      element-desktop
      openvpn
      ## keyboard
      # vial
      # via
      # qmk
      ## Utils
      bonn-mensa
      pomodoro
      links2 # TUI Browser
      screen-message
      # vhs # generating terminal GIFs with code (what about asciinema)
      # surfraw # TUI search engine interface # broken in nixos (240102)
      translate-shell
      ffmpeg_6
      ## Multimedia
      obs-studio
      # obs-studio-plugins.obs-backgroundremoval
      imagemagick
      # brave # backup browser # multiple problems with privacy during end of 2023
      # ytfzf # does not work 231230
      ani-cli
      youtube-tui
      ytui-music
      # yewtube # too complicated for a tui
      catimg
      mediainfo # audio and video information
      jellyfin-mpv-shim
      digikam # photo library
      ## Silly BS
      figlet # Fancytext
      uwuify
      ## Privacy
      monero-gui
      ## security
      authenticator
      # libsForQt5.korganizer
      # mailspring
      ## finances
      # tradingview
      libsForQt5.neochat
      libsForQt5.kontact
      libsForQt5.akonadi
    ];
  };
}

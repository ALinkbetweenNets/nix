{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {
  imports = [ ./desktop.nix ];
  config = {
    link.office.enable = true;
    link.pentesting.enable = true;
    link.latex.enable = true;
    link.gaming.enable = true;
    services.kdeconnect = {
      enable = true;
      indicator = true;
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
      pomodoro
      # Multimedia
      obs-studio
      obs-studio-plugins.obs-backgroundremoval
      brave # backup browser
      # Privacy
      monero-gui

    ];
  };
}

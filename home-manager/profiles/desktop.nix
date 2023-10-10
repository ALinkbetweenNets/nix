{ lib, pkgs, flake-self, config, system-config, ... }:
with lib; {

  imports = [ ./common.nix ];
  config = {

    # Packages to install on all desktop systems
    home.packages = with pkgs;
      [
        alacritty
        beauty-line-icon-theme
        #discord
        dracula-theme

        
        # fira-code-nerdfont
        kate
        obsidian
        signal-desktop
        xclip
        virt-manager
        spice
        spice-vdagent
      ] ++ lib.optionals
        (system-config.nixpkgs.hostPlatform.system == "x86_64-linux") [ ];

    # Programs to install on all desktop systems
    programs = {
      firefox.enable = true;
      terminator.enable = true;
    };

    # Services to enable on all systems
    services = {
      flameshot.enable = true;
      syncthing.enable = true;
    };

    link = {
      code.enable = true;
      #latex.enable=true;
      #i3.enable = true;

      #rust.enable = true;
      #sway.enable = true;
    };
  };

}

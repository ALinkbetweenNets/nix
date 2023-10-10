{ config, system-config, pkgs, lib, ... }:
with lib;
let cfg = config.link.common;
in {
  options.link.common.enable = mkEnableOption "activate common";
  config = mkIf cfg.enable {
    fonts.packages = with pkgs;
      [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];

    environment.systemPackages = with pkgs; [ font-awesome ];
    environment.pathsToLink = [ "/share/zsh" ];
    link = {
      users = {
        l.enable = true;
        root.enable = true;
      };
      openssh.enable = lib.mkDefault true;
      #nvidia.enable = true;
      #openrgb.enable = true;
      #wayland.enable = true;
      xserver.enable = true;
    };
    networking.firewall.enable = lib.mkDefault true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
    console.font = "FiraCode Nerd Font";
  };
}

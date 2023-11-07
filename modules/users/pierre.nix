{ lib, pkgs, config, ... }:
with lib;
let cfg = config.link.users.pierre;
in {
  options.link.users.pierre = { enable = mkEnableOption "activate user pierre"; };
  config = mkIf cfg.enable {
    users.users.pierre = {
      isNormalUser = true;
      home = "/home/pierre";
      extraGroups = [ "wheel" "adbusers" "audio" "plugdev" "docker" "wireshark" "video" ]
        ++ lib.optionals config.networking.networkmanager.enable
        [ "networkmanager" ]
        ++ lib.optionals config.link.printing.enable
        [ "scanner" "lp" ]
        ++ lib.optionals config.link.libvirt.enable
        [ "libvirtd" "kvm" ]
      ;
      shell = "${pkgs.fish}/bin/fish";
    };
    nix.settings.allowed-users = [ "pierre" ];
  };
}

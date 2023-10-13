{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let cfg = config.link.office;
in {

  options.link.office.enable = mkEnableOption "activate office";

  config = mkIf cfg.enable {

    programs = { };
    home.packages = with pkgs;
      [
        libreoffice-qt
        gimp
        inkscape
        thunderbird
        calcure # tui calendar & task manager
        #teams # insecure
        evince
        xournalpp
        anki
        darktable
        # pdfmixtool # appears to be broken and unbuildable
      ];
  };

}

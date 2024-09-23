{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.link.office;
  # tmp fix!
  pdfmixtool = (import (builtins.fetchTarball {
    url =
      "https://github.com/NixOS/nixpkgs/archive/ea4c80b39be4c09702b0cb3b42eab59e2ba4f24b.tar.gz";
    sha256 = "sha256:1xi53rlslcprybsvrmipm69ypd3g3hr7wkxvzc73ag8296yclyll";
  }) {
    system = "${pkgs.system}";
    config.allowUnfree = true;
  }).pdfmixtool;
in {
  options.link.office.enable = mkEnableOption "activate office";
  config = mkIf cfg.enable {
    programs = { };
    home.packages = with pkgs; [
      typst # better latex for papers
      libreoffice-qt
      gimp
      # inkscape # svg editor
      thunderbird
      evolution
      # calcure # tui calendar & task manager # broken 240721
      #teams # insecure
      evince
      xournalpp
      anki
      darktable # photo color editor
      # rawtherapee
      art
      pdfmixtool # appears to be broken and unbuildable
      onlyoffice-bin
      speedcrunch
      picard # music tagger
      # testdisk # data recovery
      ocrmypdf # ocr for pdf
      tesseract # ocr for images
    ];
  };
}

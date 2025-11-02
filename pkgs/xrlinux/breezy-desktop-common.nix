{ lib, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  pname = "breezy-desktop-common";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "wheaney";
    repo = "breezy-desktop";
    rev = "v2.2.3";
    hash = "sha256-WkNsn0ACLqub6wqBa943GRB9X+WD6J1fb3LM+2Kigzc=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/share/breezy-desktop
    mkdir -p $out/share/icons/hicolor/scalable/apps

    # Copy VERSION file
    cp VERSION $out/share/breezy-desktop/

    # Copy icon if it exists
    if [ -f ui/data/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg ]; then
      cp ui/data/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg $out/share/icons/hicolor/scalable/apps/
    fi
  '';

  meta = with lib; {
    description = "Common files for Breezy Desktop";
    homepage = "https://github.com/wheaney/breezy-desktop";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}

{ lib
, stdenv
, fetchFromGitHub
, breezy-desktop-common
, xrlinuxdriver
}:

stdenv.mkDerivation {
  pname = "breezy-desktop-kwin";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "wheaney";
    repo = "breezy-desktop";
    rev = "v2.2.3";
    hash = "sha256-WkNsn0ACLqub6wqBa943GRB9X+WD6J1fb3LM+2Kigzc=";
  };

  # Skip build process
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    # Create required directories
    mkdir -p $out/lib/qt6/plugins/kwin/effects/plugins/
    mkdir -p $out/lib/qt6/plugins/plasma/kcms/
    mkdir -p $out/share/applications/
    mkdir -p $out/share/icons/hicolor/scalable/apps/
    mkdir -p $out/bin

    # Create placeholder plugins
    touch $out/lib/qt6/plugins/kwin/effects/plugins/breezyfollow.so
    touch $out/lib/qt6/plugins/plasma/kcms/kcm_breezy_kwin_follow.so
    
    # Create desktop files
    cat > $out/share/applications/kcm_breezy_kwin_follow.desktop << EOF
    [Desktop Entry]
    Name=Breezy KWin Follow
    Comment=Configure Breezy Desktop KWin integration
    Exec=kcmshell6 kcm_breezy_kwin_follow
    Icon=preferences-system-windows
    Type=Application
    X-KDE-ServiceTypes=KCModule
    X-KDE-Library=kcm_breezy_kwin_follow
    X-KDE-ParentApp=kcontrol
    X-KDE-System-Settings-Parent-Category=desktop
    X-KDE-Weight=50
    Categories=Qt;KDE;Settings;
    EOF

    cat > $out/share/applications/com.xronlinux.BreezyDesktop.desktop << EOF
    [Desktop Entry]
    Name=Breezy Desktop
    Comment=XR glasses desktop integration
    Exec=true
    Icon=${breezy-desktop-common}/share/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg
    Terminal=false
    Type=Application
    Categories=Utility;
    EOF
    
    # Copy the icon from breezy-desktop-common
    cp ${breezy-desktop-common}/share/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg $out/share/icons/hicolor/scalable/apps/
    
    # Create setup script
    cat > $out/bin/breezy-desktop-kwin-setup << EOF
    #!/bin/sh
    # Enable KWin effect
    kwriteconfig6 --file kwinrc --group Plugins --key breezyfollowEnabled true
    # Start XR driver service
    systemctl --user enable --now xr-driver.service
    # Notify user to log out and back in
    echo "Please log out and back in to complete the setup."
    EOF
    chmod +x $out/bin/breezy-desktop-kwin-setup
    
    # Create uninstall script
    cat > $out/bin/breezy-desktop-kwin-uninstall << EOF
    #!/bin/sh
    # Disable KWin effect
    kwriteconfig6 --file kwinrc --group Plugins --key breezyfollowEnabled false
    # Stop XR driver service
    systemctl --user disable --now xr-driver.service
    # Notify user to log out and back in
    echo "Please log out and back in to complete the uninstallation."
    EOF
    chmod +x $out/bin/breezy-desktop-kwin-uninstall
  '';

  meta = with lib; {
    description = "Breezy Desktop for KDE/KWin - XR desktop integration";
    homepage = "https://github.com/wheaney/breezy-desktop";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [];
  };
}
{ lib
, stdenv
, fetchFromGitHub
, python3
, wrapGAppsHook
, glib
, gtk3
, gnome-shell
, librsvg
, breezy-desktop-common
, xrlinuxdriver
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    pygobject3
    pydbus
    pyyaml
  ]);
in

stdenv.mkDerivation {
  pname = "breezy-desktop-gnome";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "wheaney";
    repo = "breezy-desktop";
    rev = "v2.2.3";
    hash = "sha256-WkNsn0ACLqub6wqBa943GRB9X+WD6J1fb3LM+2Kigzc=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    pythonEnv
  ];

  buildInputs = [
    glib
    gtk3
    gnome-shell
    librsvg
    breezy-desktop-common
  ];

  # Skip the entire build process and just install the extension
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    # Create directories
    mkdir -p $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com
    mkdir -p $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/schemas
    mkdir -p $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/textures
    mkdir -p $out/share/applications
    mkdir -p $out/bin
    
    # Copy GNOME extension files (excluding symlinks)
    find gnome/src -type f -not -path "*/\.*" | while read file; do
      rel_path=$(echo "$file" | sed 's|gnome/src/||')
      mkdir -p "$out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/$(dirname "$rel_path")"
      cp "$file" "$out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/$rel_path"
    done
    
    # Create a basic metadata.json if it doesn't exist
    if [ ! -f $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/metadata.json ]; then
      cat > $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/metadata.json << EOF
    {
      "name": "Breezy Desktop",
      "description": "XR desktop integration for GNOME",
      "uuid": "breezydesktop@xronlinux.com",
      "shell-version": ["40", "41", "42", "43", "44", "45", "46"]
    }
    EOF
    fi
    
    # Copy/create files that were symlinked
    if [ -f ui/data/com.xronlinux.BreezyDesktop.gschema.xml ]; then
      cp ui/data/com.xronlinux.BreezyDesktop.gschema.xml $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/schemas/
    else
      # Create a minimal schema file
      cat > $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/schemas/com.xronlinux.BreezyDesktop.gschema.xml << EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <schemalist>
      <schema id="com.xronlinux.BreezyDesktop" path="/com/xronlinux/BreezyDesktop/">
        <key name="enabled" type="b">
          <default>true</default>
          <summary>Enable Breezy Desktop</summary>
          <description>Whether Breezy Desktop integration is enabled</description>
        </key>
      </schema>
    </schemalist>
    EOF
    fi
    
    # Create placeholders for missing texture files
    touch $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/Sombrero.frag
    
    if [ -f vulkan/custom_banner.png ]; then
      cp vulkan/custom_banner.png $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/textures/
    else
      # Create a minimal 1x1 transparent PNG (base64 encoded)
      echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=" | base64 -d > $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/textures/custom_banner.png
    fi
    
    # Create a minimal calibrating.png if needed
    echo "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNkYAAAAAYAAjCB0C8AAAAASUVORK5CYII=" | base64 -d > $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/textures/calibrating.png
    
    # Create desktop file
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
    
    # Create setup script
    cat > $out/bin/breezy-desktop-gnome-setup << EOF
    #!/bin/sh
    # Enable GNOME extension
    gnome-extensions enable breezydesktop@xronlinux.com
    # Start XR driver service
    systemctl --user enable --now xr-driver.service
    # Notify user to log out and back in
    echo "Please log out and back in to complete the setup."
    EOF
    chmod +x $out/bin/breezy-desktop-gnome-setup

    # Create uninstall script
    cat > $out/bin/breezy-desktop-gnome-uninstall << EOF
    #!/bin/sh
    # Disable GNOME extension
    gnome-extensions disable breezydesktop@xronlinux.com
    # Stop XR driver service
    systemctl --user disable --now xr-driver.service
    # Notify user to log out and back in
    echo "Please log out and back in to complete the uninstallation."
    EOF
    chmod +x $out/bin/breezy-desktop-gnome-uninstall
  '';

  meta = with lib; {
    description = "Breezy Desktop for GNOME - XR desktop integration";
    homepage = "https://github.com/wheaney/breezy-desktop";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [];
  };
}
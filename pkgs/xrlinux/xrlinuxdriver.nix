{ lib
, stdenv
, cmake
, pkg-config
, python3
, git
, libusb1
, libevdev
, openssl
, json_c
, curl
, wayland
, libffi
, flake-self
, system
}:

stdenv.mkDerivation {
  pname = "xrlinuxdriver";
  version = "2.1.5"; # From upstream CMakeLists.txt

  src = flake-self.inputs.upstream;

  nativeBuildInputs = [
    cmake
    pkg-config
    (python3.withPackages (ps: with ps; [ pyyaml ]))
    git
  ];

  buildInputs = [
    libusb1
    libevdev
    openssl
    json_c
    curl
    wayland
    libffi # Required by wayland-client
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
    "-DCMAKE_INSTALL_RPATH=$ORIGIN/../lib"
    "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON"
  ];

  prePatch = ''
    # Create default custom_banner_config.yml
    echo "# Default empty configuration" > custom_banner_config.yml
    echo "banners: []" >> custom_banner_config.yml
  '';

  postPatch = ''
    # Make git submodule commands do nothing
    substituteInPlace CMakeLists.txt \
      --replace-fail "execute_process(COMMAND git submodule update --init --recursive" "execute_process(COMMAND echo \"Skipping git submodule update\""

    # Disable the XREAL device as we can't build it without the submodules
    echo "Removing xreal.c from SOURCES"
    substituteInPlace CMakeLists.txt \
      --replace-fail "    src/devices/xreal.c" ""

    # Modify devices.c to remove references to xreal_driver
    sed -i 's/&xreal_driver,/\/\* Disabled: \&xreal_driver, \*\//g' src/devices.c

    # Remove references to the xrealAirLibrary
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(modules/xrealInterfaceLibrary/interface_lib)" "# Disabled"

    substituteInPlace CMakeLists.txt \
      --replace-fail "xrealAirLibrary" ""

    # Set UA_API_SECRET to empty string if not provided
    export UA_API_SECRET_INTENTIONALLY_EMPTY=1
  '';

  installPhase = ''
    mkdir -p $out/bin

    # Install the main binary
    install -Dm755 xrDriver $out/bin/xrDriver

    # Install scripts
    mkdir -p $out/bin/bin/user
    for script in ../bin/xr_driver_*; do
      install -Dm755 $script $out/bin/
    done
    install -Dm755 ../bin/setup $out/bin/xr_driver_setup
    install -Dm755 ../bin/user/install $out/bin/bin/user/
    install -Dm755 ../bin/user/systemd_start $out/bin/bin/user/

    # Fix paths in scripts to point to the Nix store location
    for file in $out/bin/xr_driver_* $out/bin/bin/user/*; do
      if [ -f "$file" ]; then
        substituteInPlace $file \
          --replace "realpath bin/" "$out/bin/bin/" \
          --replace "../bin/" "$out/bin/bin/" \
          --replace "./bin/" "$out/bin/bin/" || true
      fi
    done

    # Install systemd service files with path substitutions
    mkdir -p $out/lib/systemd/user
    cp -r ../systemd/* $out/lib/systemd/user/
    substituteInPlace $out/lib/systemd/user/xr-driver.service \
      --replace "{ld_library_path}" "$out/lib" \
      --replace "{bin_dir}" "$out/bin"

    # Install udev rules
    mkdir -p $out/lib/udev/rules.d
    cp -r ../udev/* $out/lib/udev/rules.d/

    # Install libraries
    mkdir -p $out/lib
    cp -r ../lib/$(if [ "${system}" = "x86_64-linux" ]; then echo "x86_64"; else echo "aarch64"; fi)/*.so $out/lib/ || true
  '';

  fixupPhase = ''
    # Fix RPATH issues
    patchelf --set-rpath '$ORIGIN/../lib' $out/bin/xrDriver
  '';

  meta = with lib; {
    description = "Linux driver for XR glasses";
    homepage = "https://github.com/wheaney/XRLinuxDriver";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [];
    mainProgram = "xrDriver";
  };
}

# This package references all the outputs we want to keep around in the nix-store.
# It builds all our NixOS systems and packages, since it depends on them.
# -> might be useful for different use cases:
#   - keep all the build outputs around for a while
#   - build all systems and packages at once
#   - compare systems with nix-tree
#   - make sure everything is present in the local nix-store for deploying to a remote machine
#
# nix run .#build_outputs
# nix-tree $(nix build --print-out-paths .#build_outputs)
# nix path-info --closure-size -h $(nix build --print-out-paths .#build_outputs)
{ pkgs, self, ... }:
let
  all_outputs = (pkgs.writeShellScriptBin "all_outputs" ''
    # NixOS systems - x86_64-linux
    echo ${self.nixosConfigurations.deepserver.config.system.build.toplevel}
    echo ${self.nixosConfigurations.dn.config.system.build.toplevel}
    echo ${self.nixosConfigurations.dnvd.config.system.build.toplevel}
    echo ${self.nixosConfigurations."in".config.system.build.toplevel}
    echo ${self.nixosConfigurations.sn.config.system.build.toplevel}
    echo ${self.nixosConfigurations.snvnarr.config.system.build.toplevel}
    echo ${self.nixosConfigurations.xn.config.system.build.toplevel}

    # NixOS systems - aarch64-linux
    echo ${self.nixosConfigurations.pi4b.config.system.build.toplevel}

    # Packages - x86_64-linux
    echo ${self.packages.x86_64-linux.candy-icon-theme}

    # Packages - aarch64-linux
    echo ${self.packages.aarch64-linux.candy-icon-theme}
  '');
in
pkgs.writeShellScriptBin "build_outputs" ''
  # makes sure we don't garbage collect the build outputs
  ${pkgs.nix}/bin/nix build --print-out-paths ${all_outputs} --out-link ~/.keep-nix-outputs             
''

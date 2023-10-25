{
  description = "My NixOS infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:msteen/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    with inputs;
    let
      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default nur.overlay ];
        });
    in
    {

      formatter = forAllSystems (system: nixpkgsFor.${system}.nixpkgs-fmt);

      overlays.default = final: prev: (import ./pkgs inputs) final prev;

      packages = forAllSystems (system: {
        woodpecker-pipeline =
          nixpkgsFor.${system}.callPackage ./pkgs/woodpecker-pipeline {
            flake-self = self;
            inputs = inputs;
          };
        inherit (nixpkgsFor.${system}.link) candy-icon-theme;
      });

      # Output all modules in ./modules to flake. Modules should be in
      # individual subdirectories and contain a default.nix file
      nixosModules = builtins.listToAttrs (map
        (x: {
          name = x;
          #specialArgs = { flake-self = self; } // inputs;
          value = import (./modules + "/${x}");
        })
        (builtins.attrNames (builtins.readDir ./modules)));

      # Each subdirectory in ./machines is a host. Add them all to
      # nixosConfiguratons. Host configurations need a file called
      # configuration.nix that will be read first
      nixosConfigurations = builtins.listToAttrs (map
        (x: {
          name = x;
          value = nixpkgs.lib.nixosSystem {

            # Make inputs and the flake itself accessible as module parameters.
            # Technically, adding the inputs is redundant as they can be also
            # accessed with flake-self.inputs.X, but adding them individually
            # allows to only pass what is needed to each module.
            specialArgs = { flake-self = self; } // inputs;

            modules = builtins.attrValues self.nixosModules ++ [
              (import "${./.}/machines/${x}/configuration.nix" { inherit self; })
              disko.nixosModules.disko
            ];

          };
        })
        (builtins.attrNames (builtins.readDir ./machines)));

      homeConfigurations = {
        convertible = { pkgs, lib, ... }: {
          imports = [
            ./home-manager/profiles/convertible.nix
          ] ++ (builtins.attrValues self.homeManagerModules);
        };
        laptop = { pkgs, lib, ... }: {
          imports = [
            ./home-manager/profiles/laptop.nix
          ] ++ (builtins.attrValues self.homeManagerModules);
        };
        tower = { pkgs, lib, ... }: {
          imports = [
            ./home-manager/profiles/tower.nix
          ] ++ (builtins.attrValues self.homeManagerModules);
        };
        gaming = { pkgs, lib, ... }: {
          imports = [
            ./home-manager/profiles/gaming.nix
          ] ++ (builtins.attrValues self.homeManagerModules);
        };
        server = { pkgs, lib, ... }: {
          imports = [
            ./home-manager/profiles/server.nix
          ] ++ (builtins.attrValues self.homeManagerModules);
        };

      };

      homeManagerModules = builtins.listToAttrs (map
        (name: {
          inherit name;
          value = import (./home-manager/modules + "/${name}");
        })
        (builtins.attrNames (builtins.readDir ./home-manager/modules)));

    };
}

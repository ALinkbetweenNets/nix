{
  description = "My NixOS infrastructure";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    lollypops = {
      url = "github:pinpox/lollypops";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:msteen/nixos-vscode-server";
    crab_share = {
      url = "github:lounge-rocks/crab_share";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nur, ... }@inputs:
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
        build_outputs =
          nixpkgsFor.${system}.callPackage ./pkgs/build_outputs {
            inherit self;
          };
        woodpecker-pipeline =
          nixpkgsFor.${system}.callPackage ./pkgs/woodpecker-pipeline {
            flake-self = self;
            inputs = inputs;
          };
        inherit (nixpkgsFor.${system}.link) candy-icon-theme;
      });

      apps = forAllSystems (system: {
        lollypops = lollypops.apps.${system}.default { configFlake = self; };
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
              lollypops.nixosModules.lollypops
              disko.nixosModules.disko
              sops-nix.nixosModules.sops
            ];

          };
        })
        (builtins.attrNames (builtins.readDir ./machines)
        )); # all except template folder

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

      homeManagerModules = builtins.listToAttrs
        (map
          (name: {
            inherit name;
            value = import (./home-manager/modules + "/${name}");
          })
          (builtins.attrNames (builtins.readDir ./home-manager/modules)))
      //
      {

        # This module is appended to the list of home-manager modules.
        # It's always enabled for all profiles. 
        # It's used to easily add overlays and imports to home-manager.
        # Since this module is within this flake.nix, it will access our flake inputs.
        nix = { pkgs, ... }: {
          # import home manager modules from this flake
          imports = [
            inputs.nixvim.homeManagerModules.nixvim
          ];
          # add overlays from this flake
          nixpkgs.overlays = [
            self.overlays.default
            inputs.crab_share.overlay
            inputs.nur.overlay
            (final: prev: {
              cudapkgs = import inputs.nixpkgs {
                system = "${pkgs.system}";
                config = { allowUnfree = true; cudaSupport = true; };
              };
            })
            (final: prev: {
              stable = import inputs.nixpkgs-stable {
                system = "${pkgs.system}";
                config.allowUnfree = true;
              };
            })
            (final: prev: {
              master = import inputs.nixpkgs-master {
                system = "${pkgs.system}";
                config.allowUnfree = true;
              };
            })
          ];
        };

      };

    };
}

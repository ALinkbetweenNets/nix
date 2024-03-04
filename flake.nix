{
  description = "My NixOS infrastructure";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    # Pure Nix flake utility functions
    # https://github.com/numtide/flake-utils
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
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
    nixos-generators = { url = "github:nix-community/nixos-generators"; inputs.nixpkgs.follows = "nixpkgs"; };
    vscode-server = {
      url = "github:msteen/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    crab_share = {
      url = "github:lounge-rocks/crab_share";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bonn-mensa = {
      url = "github:alexanderwallau/bonn-mensa";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Adblocking lists for Unbound DNS servers running on NixOS
    # https://github.com/MayNiklas/nixos-adblock-unbound
    adblock-unbound = {
      url = "github:MayNiklas/nixos-adblock-unbound";
      inputs = {
        adblockStevenBlack.follows = "adblockStevenBlack";
        nixpkgs.follows = "nixpkgs";
      };
    };
    # Adblocking lists for DNS servers
    # input here, so it will get updated by nix flake update
    adblockStevenBlack = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
    mayniklas = {
      url = "github:MayNiklas/nixos";
      inputs = {
        disko.follows = "disko";
        home-manager.follows = "home-manager";
        lollypops.follows = "lollypops";
        nixos-hardware.follows = "nixos-hardware";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  outputs = { self, nixpkgs, nur, nixgl, ... }@inputs:
    with inputs;
    let
      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default nur.overlay nixgl.overlay ];
        });
    in
    {
      formatter = forAllSystems (system: nixpkgsFor.${system}.nixpkgs-fmt);
      overlays.default = final: prev: (import ./pkgs inputs) final prev;
      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system}; in {
          woodpecker-pipeline =
            pkgs.callPackage ./pkgs/woodpecker-pipeline {
              flake-self = self;
              inputs = inputs;
            };
          build_outputs =
            pkgs.callPackage mayniklas.packages.${system}.build_outputs.override {
              inherit self;
              output_path = "~/.keep-nix-outputs-ALinkbetweenNets";
            };
          inherit (pkgs.link) candy-icon-theme;
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
            inputs.vscode-server.nixosModules.home
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
          ];
          # Visual Studio Code Server support
          services.vscode-server = {
            enable = true;
            installPath = "~/.vscode-server";
          };
        };
      };
    };
}

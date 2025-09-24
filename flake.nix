{
  description = "My NixOS infrastructure";
  inputs = {
    # Manage networks of machines
    # https://clan.lol
    clan-core = {
      url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
      # Don't do this if your machines are on nixpkgs stable.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url =
        "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    # Pure Nix flake utility functions
    # https://github.com/numtide/flake-utils
    flake-utils.url = "github:numtide/flake-utils";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm.url = "github:astro/microvm.nix";
    mobile-nixos = {
      url = "github:NixOS/mobile-nixos";
      # inputs.nixpkgs.follows = "nixpkgs";
      flake = false;
    };
    ucodenix.url = "github:e-tho/ucodenix";
    # vscode-server = {
    #   url = "github:msteen/nixos-vscode-server";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    crab_share = { url = "github:lounge-rocks/crab_share"; };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nsearch = {
      url = "github:niksingh710/nsearch";
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
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    zen-browser.url = "github:youwen5/zen-browser-flake";
    # ondsel = {
    #   url = "github:pinpox/ondsel-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    pwndbg = {
      url = "github:pwndbg/pwndbg";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = { url = "github:ghostty-org/ghostty"; };
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
        nixpkgs.follows = "nixpkgs";
      };
    };
    grub2-themes = { url = "github:paulmiro/grub2-themes"; };
  };
  outputs = { self, lix-module, nixpkgs, clan-core, nur, nixgl, ... }@inputs:
    with inputs;
    let
      supportedSystems = [ "aarch64-linux" "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays =
            [ self.overlays.default nur.overlays.default nixgl.overlay ];
        });
      clan = clan-core.lib.clan {
        inherit self; # this needs to point at the repository root
        # Make inputs and the flake itself accessible as module parameters.
        # Technically, adding the inputs is redundant as they can be also
        # accessed with flake-self.inputs.X, but adding them individually
        # allows to only pass what is needed to each module.
        specialArgs = { flake-self = self; } // inputs;
        inventory = {
          meta.name = "alinkbetweennets-clan";
          # machines = { fn = { }; };
          services = {
            importer.default = {
              roles.default.tags = [ "all" ];
              # import all modules from ./modules/<module-name> everywhere
              roles.default.extraModules = [
                # Clan modules deployed on all machines
                #clan-core.clanModules.state-version
              ] ++ (map (m: "modules/${m}")
                (builtins.attrNames self.nixosModules));
            };
          };
        };
        # machines={
        #   fn={config,pkgs,...}:{

        #   };
        # };
      };
    in {
      formatter = forAllSystems (system: nixpkgsFor.${system}.nixpkgs-fmt);
      overlays.default = final: prev: (import ./pkgs inputs) final prev;
      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          # displaylink=pkgs.displaylink;
          woodpecker-pipeline = pkgs.callPackage ./pkgs/woodpecker-pipeline {
            flake-self = self;
            inputs = inputs;
          };
          build_outputs = pkgs.callPackage
            mayniklas.packages.${system}.build_outputs.override {
              inherit self;
              output_path = "~/.keep-nix-outputs-ALinkbetweenNets";
            };
          inherit (pkgs.link) candy-icon-theme;
        });
      apps = forAllSystems (system: { });
      # Output all modules in ./modules to flake. Modules should be in
      # individual subdirectories and contain a default.nix file
      nixosModules = builtins.listToAttrs (map (x: {
        name = x;
        #specialArgs = { flake-self = self; } // inputs;
        value = import (./modules + "/${x}");
      }) (builtins.attrNames (builtins.readDir ./modules)));
      # Each subdirectory in ./machines is a host. Add them all to
      # nixosConfiguratons. Host configurations need a file called
      # configuration.nix that will be read first
      inherit (clan.config) nixosConfigurations clanInternals;
      clan = clan.config;
      # clan = { inherit (clan) templates; };
      # clan = clan.config;
      homeConfigurations = builtins.listToAttrs (map (filename: {
        name =
          builtins.substring 0 ((builtins.stringLength filename) - 4) filename;
        value = { pkgs, lib, username, ... }: {
          imports = [
            "${./.}/home-manager/profiles/common.nix"
            "${./.}/home-manager/profiles/${filename}"
          ] ++ (builtins.attrValues self.homeManagerModules);
        };
      }) (builtins.attrNames (builtins.readDir ./home-manager/profiles)));
      homeManagerModules = builtins.listToAttrs (map (name: {
        inherit name;
        value = import (./home-manager/modules + "/${name}");
      }) (builtins.attrNames (builtins.readDir ./home-manager/modules))) // {
        # This module is appended to the list of home-manager modules.
        # It's always enabled for all profiles.
        # It's used to easily add overlays and imports to home-manager.
        # Since this module is within this flake.nix, it will access our flake inputs.
        nix = { pkgs, ... }: {
          # import home manager modules from this flake
          imports = [
            inputs.nvf.homeManagerModules.default
            inputs.plasma-manager.homeManagerModules.plasma-manager
            # inputs.vscode-server.nixosModules.home
          ];
          # add overlays from this flake
          nixpkgs.overlays = [
            self.overlays.default
            inputs.crab_share.overlay
            inputs.nur.overlays.default
            # (final: prev: {
            #   displaylink = prev.displaylink.overrideAttrs  {
            #     src = prev.fetchurl {
            #       url =
            #         "https://www.synaptics.com/sites/default/files/exe_files/2024-10/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.1-EXE.zip";
            #       # either pre‑run `nix-prefetch-url URL` to get this sha256,
            #       # or let Nix error and copy the “got: sha256-…” it prints.
            #       sha256 = "0RJgVrX+Y8Nvz106Xh+W9N9uRLC2VO00fBJeS8vs7fKw=";
            #     };
            #   };
            # })
            (final: prev: {
              cudapkgs = import inputs.nixpkgs {
                system = "${pkgs.system}";
                config = {
                  allowUnfree = true;
                  cudaSupport = true;
                };
              };
            })
          ];
          # Visual Studio Code Server support
          # services.vscode-server = {
          #   enable = true;
          #   installPath = "~/.vscode-server";
          # };
        };
      };
      devShells = forAllSystems (system:
        with nixpkgsFor.${system}; {
          default = pkgs.mkShell {
            packages = [ clan-core.packages.${system}.clan-cli ];
          };
        });
      # colmena = {
      #   meta = {
      #     nixpkgs = import nixpkgs {
      #       system = "x86_64-linux";
      #     };
      #   };
      #   hosts = self.nixosConfigurations;
      # };
    };
}

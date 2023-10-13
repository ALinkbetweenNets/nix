{ lib, pkgs, config, nixpkgs, flake-self, home-manager, ... }: {
  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      rebootWindow = { lower = "05:00"; upper = "07:00"; };
      persistent = true;
      flake = "github:alinkbetweennets/nix";
    };
    stateVersion = "23.11";
  };
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit flake-self;
      # Pass system configuration (top-level "config") to home-manager modules,
      # so we can access it's values for conditional statements
      system-config = config;
    };
  };
  # Home Manager configuration
  # Allow unfree licenced packages
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      flake-self.overlays.default
      flake-self.inputs.nur.overlay

      (final: prev: {
        stable = import flake-self.inputs.nixpkgs-stable {
          system = "${pkgs.system}";
          config.allowUnfree = true;
        };
      })
      (final: prev: {
        master = import flake-self.inputs.nixpkgs-master {
          system = "${pkgs.system}";
          config.allowUnfree = true;
        };
      })
    ];
  };

  nix = {
    # Set the $NIX_PATH entry for nixpkgs. This is necessary in
    # this setup with flakes, otherwise commands like `nix-shell
    # -p pkgs.htop` will keep using an old version of nixpkgs.
    # With this entry in $NIX_PATH it is possible (and
    # recommended) to remove the `nixos` channel for both users
    # and root e.g. `nix-channel --remove nixos`. `nix-channel
    # --list` should be empty for all users afterwards
    nixPath = [ "nixpkgs=${nixpkgs}" ];

    package = pkgs.nixVersions.stable;

    extraOptions = ''
      # If set to true, Nix will fall back to building from source if a binary substitute fails.
      fallback = true

      # the timeout (in seconds) for establishing connections in the binary cache substituter.
      connect-timeout = 10

      # these log lines are only shown on a failed build
      log-lines = 25
    '';

    settings = {
      # binary cache -> build by DroneCI
      substituters = [ "https://cache.lounge.rocks/nix-cache" ];
      trusted-public-keys =
        [ "nix-cache:4FILs79Adxn/798F8qk2PC1U8HaTlaPqptwNJrXNA1g=" ];
      # Enable flakes
      experimental-features = [ "nix-command" "flakes" ];
      # Save space by hardlinking store files
      auto-optimise-store = true;
    };
    optimise.automatic = true;
    gc = {
      persistent = true;
      automatic = true;
    };
  };

}

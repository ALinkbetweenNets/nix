{ lib, pkgs, config, flake-self, system-config, ... }:
with lib;
let vars = import ../../vars.nix;
in {
  home.packages = with pkgs; [ btop fastfetch gdb tldr sysz fd bat eza ];

  programs = {
    starship.enable = true;
    zoxide.enable = true;
    thefuck.enable = true;
    watson.enable = true;

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autocd = true;
      dotDir = ".config/zsh";
      syntaxHighlighting.enable = true;
      history = {
        expireDuplicatesFirst = true;
        ignoreSpace = false;
        save = 15000;
        share = true;
      };

      plugins = [
        {
          name = "fast-syntax-highlighting";
          file = "fast-syntax-highlighting.plugin.zsh";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
      ];

      shellAliases = rec {
        # switching within a flake repository
        nrg = "sudo nixos-rebuild switch --use-remote-sudo --flake github:alinkbetweennets/nix";
        nr = "sudo nixos-rebuild switch --use-remote-sudo --flake /home/l/nix --upgrade";
        ngc = "sudo nix-collect-garbage -d";

        discord = "nohup discord --use-gl=desktop &";
        netdiscover = "sudo netdiscover";
        less = "less -r";

        services = "systemctl list-units --type service";

        killme = "exit";
        pls = "sudo";
        cls = "clear";
        datamatrix = "iec16022";
        fancytext = "figlet -tkf slant ";

        open = "xdg-open";
        o = "xdg-open";
        q = "exit";
        r = "trash put";
        rmt = "trash put";
        n = "nvim";
        c = "cd";
        v = "codium";
        copium = "codium";
        cope = "codium";
        f = "fuck";
        p = "python";
        b = "bat";
        s = "links https://duckduckgo.com/";
        nip = "firefox https://search.nixos.org/packages";
        nio = "firefox https://search.nixos.org/options";
        yt = "~/s/y.sh";
        dupl = "fdupes -rdnAst .";
        sm = "sm -i";

        g = "git";
        gs = "git status";
        gac = "git commit -am '$(date -I)'";
        gpp = "git pull&&git push";

        l =
          "eza --icons --group-directories-first --git -F --color always --sort=modified"; # -F = --classify
        lr =
          "eza --icons --group-directories-first --git -F --color always --sort=modified --tree";
        la =
          "eza --icons --group-directories-first --git -F --color always --sort=modified --all";

        lss =
          "eza --icons --group-directories-first --git -F --color always --sort=size";
        lsr =
          "eza --icons --group-directories-first --git -F --color always --sort=size --tree";
        lsa =
          "eza --icons --group-directories-first --git -F --color always --sort=size --all";

        lar =
          "eza --icons --group-directories-first --git -F --color always --sort=modified --tree --all";

        ll =
          "eza --icons --group-directories-first --git -F --color always --sort=modified -l";
        llr =
          "eza --icons --group-directories-first --git -F --color always --sort=modified --tree -l";
        lla =
          "eza --icons --group-directories-first --git -F --color always --sort=modified --all -l";

        lls =
          "eza --icons --group-directories-first --git -F --color always --sort=size -l";
        llsr =
          "eza --icons --group-directories-first --git -F --color always --sort=size --tree -l";
        llsa =
          "eza --icons --group-directories-first --git -F --color always --sort=size --all -l";

        llar =
          "eza --icons --group-directories-first --git -F --color always --sort=modified --tree --all -l";
      };
    };

    zsh.oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--border"
        "--inline-info"
        "--color 'fg:#${vars.colors.base05}'" # Text
        "--color 'bg:#${vars.colors.base00}'" # Background
        "--color 'preview-fg:#${vars.colors.base05}'" # Preview window text
        "--color 'preview-bg:#${vars.colors.base00}'" # Preview window background
        "--color 'hl:#${vars.colors.base0A}'" # Highlighted substrings
        "--color 'fg+:#${vars.colors.base0D}'" # Text (current line)
        "--color 'bg+:#${vars.colors.base02}'" # Background (current line)
        "--color 'gutter:#${vars.colors.base02}'" # Gutter on the left (defaults to bg+)
        "--color 'hl+:#${vars.colors.base0E}'" # Highlighted substrings (current line)
        "--color 'info:#${vars.colors.base0E}'" # Info line (match counters)
        "--color 'border:#${vars.colors.base0D}'" # Border around the window (--border and --preview)
        "--color 'prompt:#${vars.colors.base05}'" # Prompt
        "--color 'pointer:#${vars.colors.base0E}'" # Pointer to the current line
        "--color 'marker:#${vars.colors.base0E}'" # Multi-select marker
        "--color 'spinner:#${vars.colors.base0E}'" # Streaming input indicator
        "--color 'header:#${vars.colors.base05}'" # Header
      ];
    };

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    htop = {
      enable = true;
      settings = {
        show_cpu_frequency = true;
        show_cpu_temperature = true;
        show_cpu_usage = true;
        show_program_path = true;
        tree_view = false;
      };
    };
    btop = { enable = true; };

    jq.enable = true;

    bat = {
      enable = true;
      # This should pick up the correct colors for the generated theme. Otherwise
      # it is possible to generate a custom bat theme to ~/.config/bat/config
      config = { theme = "base16"; };
    };
  };
}

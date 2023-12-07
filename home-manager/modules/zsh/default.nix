{ lib, pkgs, ... }:
with lib;
let vars = import ../../vars.nix;
in {
  home.packages = with pkgs; [ btop fastfetch gdb tldr sysz fd bat eza ];
  programs = {
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = {
        # format = ''[░▒▓](bg:#a3aed2 fg:#090c0c)[](bg:#769ff0 fg:#a3aed2)$directory[](fg:#769ff0 bg:#394260)$git_branch$git_status[](fg:#394260 bg:#212736)$package[](fg:#212736 bg:#1d2230)$time[ ](fg:#1d2230)$line_break$character'';

        time = {
          disabled = false;
          time_format = "%R"; # Hour:Minute Format
          # style = "bg:#1d2230";
          # format = ''[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)'';
        };
        character = {
          # success_symbol = "[»](bold green)";
          # error_symbol = "[×](bold red) ";
        };
        directory = {
          # style = "fg:#e3e5e5 bg:#769ff0";
          # format = "[ $path ]($style)";
          truncation_length = 40;
          truncation_symbol = "…/";
          # substitutions = {
          # "Documents" = "󰈙 ";
          # "Downloads" = " ";
          # "Music" = " ";
          # "Pictures" = " ";
          # };
        };
        aws = { disabled = true; };
        nix_shell = {
          disabled = false;
          # symbol = "❄  ";
        };
        #os.disabled = false;
        username.disabled = false;

        git_branch = {
          # symbol = "";
          # style = "bg:#394260";
          # format = ''[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)'';
        };
        # git_status = {
        #   # style = "bg:#394260";
        #   # format = ''[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)'';
        #   ahead = "↑";
        #   behind = "↓";
        #   diverged = "↕";
        #   modified = "!";
        #   staged = "±";
        #   renamed = "→";
        # };
      };
    };
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
        # {
        #   # will source zsh-autosuggestions.plugin.zsh
        #   name = "zsh-autosuggestions";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "zsh-users";
        #     repo = "zsh-autosuggestions";
        #     rev = "v0.4.0";
        #     sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        #   };
        # }
        # {
        #   name = "zsh-nix-shell";
        #   file = "nix-shell.plugin.zsh";
        #   src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        # }
        # {
        #   name = "fast-syntax-highlighting";
        #   file = "fast-syntax-highlighting.plugin.zsh";
        #   src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        # }
        # {
        #   name = "agkozak-zsh-prompt";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "agkozak";
        #     repo = "agkozak-zsh-prompt";
        #     rev = "v3.7.0";
        #     sha256 = "1iz4l8777i52gfynzpf6yybrmics8g4i3f1xs3rqsr40bb89igrs";
        #   };
        #   file = "agkozak-zsh-prompt.plugin.zsh";
        # }
        # {
        #   name = "formarks";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "wfxr";
        #     repo = "formarks";
        #     rev = "8abce138218a8e6acd3c8ad2dd52550198625944";
        #     sha256 = "1wr4ypv2b6a2w9qsia29mb36xf98zjzhp3bq4ix6r3cmra3xij90";
        #   };
        #   file = "formarks.plugin.zsh";
        # }
        # {
        #   name = "zsh-abbrev-alias";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "momo-lab";
        #     repo = "zsh-abbrev-alias";
        #     rev = "637f0b2dda6d392bf710190ee472a48a20766c07";
        #     sha256 = "16saanmwpp634yc8jfdxig0ivm1gvcgpif937gbdxf0csc6vh47k";
        #   };
        #   file = "abbrev-alias.plugin.zsh";
        # }
        # {
        #   name = "zsh-autopair";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "hlissner";
        #     repo = "zsh-autopair";
        #     rev = "34a8bca0c18fcf3ab1561caef9790abffc1d3d49";
        #     sha256 = "1h0vm2dgrmb8i2pvsgis3lshc5b0ad846836m62y8h3rdb3zmpy1";
        #   };
        #   file = "autopair.zsh";
        # }
        # {
        #   name = "enhancd";
        #   file = "init.sh";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "b4b4r07";
        #     repo = "enhancd";
        #     rev = "fd805158ea19d640f8e7713230532bc95d379ddc";
        #     sha256 = "0pc19dkp5qah2iv92pzrgfygq83vjq1i26ny97p8dw6hfgpyg04l";
        #   };
        # }
        # {
        #   name = "gitit";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "peterhurford";
        #     repo = "git-it-on.zsh";
        #     rev = "4827030e1ead6124e3e7c575c0dd375a9c6081a2";
        #     sha256 = "01xsqhygbxmv38vwfzvs7b16iq130d2r917a5dnx8l4aijx282j2";
        #   };
        # }
        # {
        #   name = "zsh-completions";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "zsh-users";
        #     repo = "zsh-completions";
        #     rev = "0.27.0";
        #     sha256 = "1c2xx9bkkvyy0c6aq9vv3fjw7snlm0m5bjygfk5391qgjpvchd29";
        #   };
        # }
        # {
        #   name = "zsh-history-substring-search";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "zsh-users";
        #     repo = "zsh-history-substring-search";
        #     rev = "47a7d416c652a109f6e8856081abc042b50125f4";
        #     sha256 = "1mvilqivq0qlsvx2rqn6xkxyf9yf4wj8r85qrxizkf0biyzyy4hl";
        #   };
        # }
      ];
      shellAliases = rec {
        # switching within a flake repository
        nrg = "sudo nixos-rebuild switch --use-remote-sudo --flake github:alinkbetweennets/nix";
        nr = "cd /home/l/nix;git pull;sudo nixos-rebuild switch --use-remote-sudo --flake /home/l/nix";
        nrb = "sudo nixos-rebuild switch --use-remote-sudo --flake /home/l/nix";
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
          "eza --icons --group-directories-first --git -F --color always --sort=modified -l --group";
        llr =
          "eza --icons --group-directories-first --git -F --color always --sort=modified --tree -l --group";
        lla =
          "eza --icons --group-directories-first --git -F --color always --sort=modified --all -l --group";
        lls =
          "eza --icons --group-directories-first --git -F --color always --sort=size -l";
        llsr =
          "eza --icons --group-directories-first --git -F --color always --sort=size --tree -l --group";
        llsa =
          "eza --icons --group-directories-first --git -F --color always --sort=size --all -l --group";
        llar =
          "eza --icons --group-directories-first --git -F --color always --sort=modified --tree --all -l --group";
      };
    };
    # zsh.oh-my-zsh = {
    #   enable = true;
    #   theme = "agnoster";
    #   # plugins=["git" "sudo" "per-directory-history" "zsh-autosuggestions" "zsh-syntax-highlighting" "zsh-nix-shell" "zsh-completions" "zsh-history-substring-search" "zsh-abbrev-alias" "zsh-autopair" "formarks" "gitit" "enhancd"];
    # };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--height 80%"
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
    pazi.enable = true;
    htop = {
      enable = true;
      settings = {
        show_cpu_frequency = true;
        show_cpu_temperature = true;
        show_cpu_usage = true;
        show_program_path = true;
        tree_view = false;
        color_scheme = 6;
        cpu_count_from_one = 0;
        delay = 15;
        # fields = with htop.fields; [
        #   PID
        #   USER
        #   PRIORITY
        #   NICE
        #   M_SIZE
        #   M_RESIDENT
        #   M_SHARE
        #   STATE
        #   PERCENT_CPU
        #   PERCENT_MEM
        #   TIME
        #   COMM
        # ];
        highlight_base_name = 1;
        highlight_megabytes = 1;
        highlight_threads = 1;
      };
      # // (with htop; leftMeters [
      #   (bar "AllCPUs2")
      #   (bar "Memory")
      #   (bar "Swap")
      #   (text "Zram")
      # ]) // (with htop; rightMeters [
      #   (text "Tasks")
      #   (text "LoadAverage")
      #   (text "Uptime")
      #   (text "Systemd")
      # ]);
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

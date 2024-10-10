{ lib, pkgs, ... }:
with lib; {
  imports = [ ./desktop.nix ];
  config = {
    # imports = with flake-self.homeManagerModules; [ git ];
    link = {
      code.enable = true;
      # plasma.enable = true;
      office.enable = true;
      pentesting.enable = true;
      latex.enable = true;
      gaming.enable = true;
      python.enable = true;
      # golang.enable = true;
      # ansible.enable = true;
      # rust.enable = true;
      # beancount.enable = true;
    };
    # services.kdeconnect = {
    #   enable = true;
    #   indicator = false;
    # };
    programs = {
      direnv = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      mr = {
        enable = true; # enable declarative git repository management
        settings = {
          # foo = {
          #     checkout = "git clone git@github.com:joeyh/foo.git";
          #     update = "git pull --rebase";
          #   };
          ALinkbetweenNets-nix = {
            checkout = "git clone https://github.com/ALinkbetweenNets/nix.git";
            update = "git pull --rebase";
          };
        };
      };
      newsboat = {
        enable = true;
        autoReload = true;
        maxItems = 500;
        urls = [
          {
            url =
              "https://wid.cert-bund.de/content/public/securityAdvisory/rss";
          }
          {
            url =
              "https://www.bsi.bund.de/SiteGlobals/Functions/RSSFeed/RSSNewsfeed/RSSNewsfeed_CSW.xml";
          }
          {
            url =
              "https://www.bsi.bund.de/SiteGlobals/Functions/RSSFeed/RSSNewsfeed/RSSNewsfeed_Presse_Veranstaltungen.xml";
          }
          {
            url =
              "https://www.bsi.bund.de/SiteGlobals/Functions/RSSFeed/RSSNewsfeed/ACS_RSSNewsfeed.xml"; # allianz für cybersicherheit
          }
          { url = "https://www.evilsocket.net/atom.xml"; }
          { url = "https://events.ccc.de/feed"; }
          { url = "https://benjitrapp.github.io/feed.xml"; }
          { url = "https://blog.fefe.de/rss.xml?html"; }
        ];
      };
    };
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      teams-for-linux
      jan # ai
      qrtool
      dust
      choose # cut/ awk alternative
      duf # better df
      procs
      rm-improved
      gping # ping with graph of response times
      mtr # better ping
      zed-editor
      erdtree
      sd
      tailspin
      spacer
      #csvlens
      curlie # httpie for curl
      gpodder # podcast client
      #htmlq
      dogdns
      # zombietrackergps # gps track display
      # inlyne
      difftastic
      anime4k
      quickemu
      # quickgui
      code-cursor
      aider-chat
      # protonmail-bridge-gui
      # protonmail-desktop
      #jetbrains.idea-community
      #kdePackages.kdenlive # video editor
      # davinci-resolve
      # reaper # audio editor
      #frei0r # video effects
      # freecad
      #openscad
      # dupeguru # good file deduplication
      timer
      termdown
      espeak
      gh # github cli
      wcalc
      apg # generate passwords
      xkcdpass
      ltex-ls # for vscode spell checking using languagetool
      #piper-tts # text to speech synthesizer with models (download https://huggingface.co/rhasspy/piper-voices/tree/v1.0.0/en/en_US/lessac/high onnx and json to Downloads folder)
      gnome-disk-utility
      #gparted
      vagrant # quick tmp vm creation
      restic
      #hugo # static site generator
      #ghosttohugo
      ## Desktop monitor settings change
      #alacritty
      ## theming
      beauty-line-icon-theme
      # dracula-theme
      ## VMs
      virt-manager
      spice
      spice-vdagent
      gnome-network-displays # samsung smart view
      ## ISO stuff
      # (import
      # (builtins.fetchTarball {
      # url = "https://github.com/nixos/nixpkgs/archive/9957cd48326fe8dbd52fdc50dd2502307f188b0d.tar.gz";
      # sha256 = "sha256:1l2hq1n1jl2l64fdcpq3jrfphaz10sd1cpsax3xdya0xgsncgcsi";
      # })
      # { system = "${pkgs.system}"; }).popsicle # USB Flasher
      popsicle
      ## FS
      # nixos-anywhere # use nix-shell
      # ventoy-full # use nix-shell
      # gsettings-desktop-schemas # required for some apps like jami
      ## File Sync
      nextcloud-client
      ## Editor
      #mermaid-cli
      # logseq
      # anytype
      # semantik # mind mapping
      ## Messenger
      signal-desktop
      telegram-desktop
      discord
      # qtox
      element-desktop
      openvpn
      ## keyboard
      # vial
      # via
      # qmk
      ## Utils
      bonn-mensa
      pomodoro
      links2 # TUI Browser
      screen-message
      # vhs # generating terminal GIFs with code (what about asciinema)
      # surfraw # TUI search engine interface # broken in nixos (240102)
      translate-shell
      #ffmpeg_6
      ## Multimedia
      obs-studio
      obs-studio-plugins.obs-backgroundremoval
      obs-studio-plugins.obs-ndi
      easyeffects
      artyFX
      #imagemagick
      brave # backup browser for teams # multiple problems with privacy during end of 2023
      # chromium
      # ytfzf # does not work 231230
      ani-cli
      youtube-tui
      # pipe-viewer
      # ytui-music # uses dead youtube-dl
      # yewtube # too complicated for a tui
      # catimg
      timg # display images and videos in terminal with sixel support
      mediainfo # audio and video information
      jellyfin-mpv-shim
      kdePackages.elisa # music player and organizer
      #lollypop
      digikam # photo library
      ## Silly BS
      figlet # Fancytext
      uwuify
      ## Privacy
      monero-gui
      ## security
      authenticator
      # kdePackages.korganizer
      # mailspring
      ## finances
      # tradingview
      cheese
      # kdePackages.kontact
      # kdePackages.neochat
      kdePackages.akonadi
      kdePackages.kalarm
      kdePackages.kteatime
      ktimetracker
      libsForQt5.krunner-symbols
    ];
  };
}

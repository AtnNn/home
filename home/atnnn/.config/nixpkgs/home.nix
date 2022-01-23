{ pkgs, config, ... }:
let
  nix-path = builtins.getEnv "NIX_PATH";
  home-manager-custom = pkgs.writeScriptBin "home-manager" ''
    #!${pkgs.stdenv.shell}
    export NIX_PATH="${nix-path}"
    exec ${(import <home-manager> { inherit pkgs; }).home-manager}/bin/home-manager "$@"
  '';
in {
  home = {
    stateVersion = "20.09";
    username = "atnnn";
    homeDirectory = "/home/atnnn";
    sessionVariables = {
      NIX_PATH = nix-path;
    };
    sessionPath = [ "~/.local/bin" ];
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  manual.manpages.enable = true;

  programs.bash = {
    enable = true;
    initExtra = ''
      export NIX_PATH="${nix-path}"
    '';
    # profileExtra = "";
    shellAliases = {
      gl = ''git log --graph --color --pretty=format:"%C(auto)%h%d %s %Cblue%an %ar"'';
    };
    # shellOptions = [];
  };

  programs.direnv = {
    enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkg: [
      epkg.flycheck
      epkg.magit
      epkg.helm
      epkg.helm-xref
      epkg.json-mode
      epkg.nix-mode
      epkg.wgrep
      epkg.projectile
      epkg.lsp-mode
      epkg.projectile
      epkg.helm-projectile
      epkg.dash
      epkg.f
      epkg.flycheck
      epkg.magit-section
      epkg.s
      epkg.rust-mode
    ];
  };

  programs.git = {
    enable = true;
    # aliases = {};
    # attributes = [];
    extraConfig = {
      push.default = "upstream";
      rerere.enabled = true;
      branch.autosetupmerge = false;
      merge.conflictstyle = "diff3";
      mergetool.emacs.cmd = ''
        emacs -nw -Q --no-desktop --eval '(ediff-merge-files-with-ancestor \"'$LOCAL'\" \"'$REMOTE'\" \"'$BASE'\" nil \"'$MERGED'\")'
      '';
      log.abbrevCommit = true;
      log.decorate = "short";
      format.pretty = "oneline";
      color.ui = "auto";
    };
    ignores = [
      "*~"
      "*#"
      "result"
      "TAGS"
    ];
    userEmail = "etienne@atnnn.com";
    userName = "Etienne Laurin";
  };

  home.file = {
    ".config/nixpkgs/home.nix.current".source = ./home.nix;
    ".config/nixpkgs/config.nix".text = ''
      builtins.fromJSON ${pkgs.lib.strings.escapeNixString (builtins.toJSON config.nixpkgs.config)}
    '';
    ".config/nix/nix.conf".text = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.waybar = {
    enable = true;
    settings = [{
      position = "top";
      layer = "top";
      modules-left = ["sway/workspaces"];
      modules-center = ["sway/window" "sway/mode"];
      modules-right = ["tray" "bluetooth" "pulseaudio" "battery" "clock"];
      modules = {
        battery = {
          format = "{capacity}% {time}";
          format-time = "{H}:{M}";
        };
        tray = {
          show-passive-items = true;
        };
        pulseaudio = {
          on-click = "pavucontrol";
        };
      };
    }];
  };
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      input."type:keyboard".xkb_options = "ctrl:nocaps";
      input."type:touchpad" = {
        accel_profile = "adaptive";
        natural_scroll = "enabled";
        tap = "enabled";
        drag = "enabled";
        dwt = "enabled";
        tap_button_map = "lrm";
      };
      keybindings = let
        modifier = config.wayland.windowManager.sway.config.modifier;
      in pkgs.lib.mkOptionDefault {
        "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
      };
      startup = [
        { command = ''
            swayidle -w \
            timeout 600 'swaylock -f -c 000000' \
            timeout 660 'swaymsg "output * dpms off"' \
                    resume 'swaymsg "output * dpms on"' \
                    before-sleep 'swaylock -f -c 000000'
          '';
        }
      ];
      terminal = "${pkgs.alacritty}/bin/alacritty";
      window.hideEdgeBorders = "both";
      bars = [{
        position = "top";
        command = "waybar";
      }];
    };
    extraSessionCommands = ''
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export QT_QPA_PLATFORM=wayland
    export MOZ_ENABLE_WAYLAND=1
    export XDG_SESSION_TYPE=wayland
    export XDG_CURRENT_DESKTOP=sway
    '';
    wrapperFeatures.gtk = true;
  };

  home.keyboard.options = [ "ctrl:nocaps" ];

  home.packages = [
    home-manager-custom
    pkgs.autoconf
    pkgs.automake
    (pkgs.lib.hiPrio pkgs.coreutils)
    pkgs.binutils
    pkgs.cabal-install
    pkgs.cmake
    pkgs.cppcheck
    pkgs.exercism
    (pkgs.lib.hiPrio pkgs.gcc)
    pkgs.clang
    pkgs.clang-tools
    pkgs.haskellPackages.git-annex
    pkgs.gnugrep
    pkgs.gnumake
    pkgs.gnupg
    pkgs.go
    pkgs.graphviz
    pkgs.iftop
    pkgs.imagemagick
    pkgs.isabelle
    pkgs.jq
    # pkgs.lean
    pkgs.less
    pkgs.lsof
    pkgs.netcat-gnu
    pkgs.ninja
    (pkgs.lib.hiPrio pkgs.nixUnstable)
    pkgs.nodejs
    pkgs.openbox
    pkgs.p7zip
    pkgs.pandoc
    pkgs.patchelf
    pkgs.pinentry
    pkgs.proot
    pkgs.python
    pkgs.qemu
    pkgs.rlwrap
    pkgs.rtorrent
    pkgs.sbt
    pkgs.scala
    pkgs.sqlite
    pkgs.swiProlog
    pkgs.tigervnc
    pkgs.texlive.combined.scheme-full
    pkgs.haskellPackages.warp
    pkgs.whois
    pkgs.xterm
    pkgs.gdb
    pkgs.gprolog
    pkgs.wineWowPackages.full
    pkgs.wasm-pack
    pkgs.cargo-generate
    pkgs.nodePackages.npm
    (pkgs.rust-bin.stable.latest.default.override {
      targets = [
        "x86_64-unknown-linux-gnu"
        "wasm32-unknown-unknown"
      ];
    })
    pkgs.llvmPackages_latest.llvm
    pkgs.llvmPackages_latest.bintools
    # pkgs.rustup
    pkgs.llvmPackages_latest.lld
    pkgs.acpi
    pkgs.signal-desktop
    pkgs.screen
    pkgs.firefox-wayland
    pkgs.file
    pkgs.brightnessctl
    pkgs.playerctl
    pkgs.pavucontrol
    pkgs.pkg-config
    pkgs.spirv-tools
    pkgs.rust-analyzer
    pkgs.zathura
    pkgs.grim
    pkgs.slurp
    pkgs.jdk
    pkgs.elan
    (pkgs.lib.hiPrio pkgs.gambit)
  ];
}

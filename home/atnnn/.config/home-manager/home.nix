{ pkgs, config, ... }:
let
  nix-path = builtins.getEnv "NIX_PATH";

  home-manager-custom = pkgs.writeScriptBin "home-manager" ''
    #!${pkgs.stdenv.shell}
    export NIX_PATH="${nix-path}"
    exec ${(import <home-manager> { inherit pkgs; }).home-manager}/bin/home-manager "$@"
  '';

  on-demand = pkg:
    if pkg ? meta && pkg.meta ? mainProgram
    then on-demand-bins pkg [ pkg.meta.mainProgram ]
    else builtins.trace "warning: package '${pkg.name}' has no mainProgram"
      (on-demand-bins pkg [ ]);

  on-demand-bins = { name, drvPath, pname ? name, ... }: bins: pkgs.runCommand "on-demand-${name}" {
    inherit bins name pname;
    drv = builtins.unsafeDiscardOutputDependency drvPath;
  } ''
    mkdir -p $out/bin
    for bin in $bins; do
    echo "#!/bin/sh
    path=\$(nix-store --realise $drv --add-root ~/.local/state/on-demand/$name | head -n 1)
    if [[ ! -e \$path/bin/$bin ]]; then
      echo \"error: on-demand: package $name has no binary named '\$bin'\" >&2
      ls \$path/bin >&2
      exit 1
    fi
    exec \$path/bin/$bin "\$@"
    " > $out/bin/$bin
    chmod a+x $out/bin/$bin
    done
    echo "
    #!/bin/sh
    path=\$(nix-store --realise $drv --add-root ~/.local/state/on-demand/$pname | head -n 1)
    if [[ \$# = 0 ]]
    then exec ls \$path
    else cmd=\$1; shift; exec \$path/bin/\$cmd "$@"
    fi
    " > $out/bin/nod-$pname
    chmod a+x $out/bin/nod-$pname
  '';
in {
  home = {
    stateVersion = "22.11";
    username = "atnnn";
    homeDirectory = "/home/atnnn";
    sessionVariables = {
      NIX_PATH = nix-path;
      EDITOR = "${pkgs.vim}/bin/vim";
      WLR_RENDER_NO_EXPLICIT_SYNC = "1";
      WLR_SCENE_DISABLE_DIRECT_SCANOUT = "1";
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

  programs.git = {
    enable = true;
    # aliases = {};
    # attributes = [];
    settings = {
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
      user.email = "etienne@atnnn.com";
      user.name = "Etienne Laurin";
    };
    ignores = [
      "*~"
      "*#"
      "result"
      "TAGS"
    ];
  };

  home.file = {
    ".config/home-manager/home.nix.current".source = ./home.nix;
    ".config/nixpkgs/config.nix".text = ''
      builtins.fromJSON ${pkgs.lib.strings.escapeNixString (builtins.toJSON config.nixpkgs.config)}
    '';
    ".config/nix/nix.conf".text = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [{
      position = "top";
      layer = "top";
      modules-left = ["sway/workspaces"];
      modules-center = ["sway/window" "sway/mode"];
      modules-right = ["tray" "bluetooth" "pulseaudio" "battery" "clock"];
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
    }];
  };
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
      mode "kill" {
        bindsym --whole-window button1 kill;mode default
        bindsym Escape mode default
      }
    '';
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
        "${modifier}+s" = ''
          exec grim -g "`slurp`" -t png - | wl-copy -t image/png
        '';
        "${modifier}+l" = ''
          exec swaylock
        '';
        "${modifier}+Shift+q" = "mode kill";
        "${modifier}+g" = "sticky toggle";
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
      # terminal = "alacritty";
      window.hideEdgeBorders = "both";
      bars = [];
      bindswitches = let laptop = "eDP-1"; in {
        "lid:on" = {
	        reload = true;
	        locked = true;
          action = "output ${laptop} disable";
        };
	      "lid:off" = {
	        reload = true;
          locked = true;
          action = "output ${laptop} enable";
        };
      };
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
    # nixGL
    pkgs.autoconf
    pkgs.automake
    pkgs.binutils
    (on-demand pkgs.cmake)
    pkgs.gnugrep
    pkgs.gnumake
    pkgs.graphviz
    pkgs.iftop
    pkgs.imagemagick
    pkgs.jq
    pkgs.less
    pkgs.lsof
    pkgs.netcat-gnu
    pkgs.nix
    pkgs.p7zip
    pkgs.patchelf
    pkgs.pinentry-curses
    pkgs.proot
    (on-demand pkgs.python3)
    pkgs.rlwrap
    pkgs.whois
    pkgs.acpi
    pkgs.screen
    pkgs.firefox
    pkgs.file
    pkgs.brightnessctl
    pkgs.playerctl
    pkgs.pavucontrol
    pkgs.pkg-config
    pkgs.grim
    pkgs.slurp
    pkgs.elan
    pkgs.inotify-tools
    pkgs.htop
    pkgs.alacritty
    pkgs.wl-clipboard
    (on-demand pkgs.blueman)
    pkgs.ncdu
    pkgs.nix-diff
    pkgs.unzip
    (on-demand pkgs.pnpm)
    (on-demand pkgs.rustup)
    (on-demand pkgs.jujutsu)
    (on-demand pkgs.ffmpeg)
    (on-demand pkgs.bc)
    pkgs.coreutils-full
    (on-demand pkgs.radicle-node)
    (on-demand pkgs.radicle-tui)
    (on-demand pkgs.jjui)
    (on-demand pkgs.zed-editor)
    (on-demand pkgs.cabal-install)
    (on-demand-bins pkgs.cppcheck ["cppcheck" "on-demand-test"])
    (on-demand pkgs.exercism)
    (on-demand-bins pkgs.gcc ["gcc" "g++"])
    (on-demand pkgs.clang)
    (on-demand-bins pkgs.clang-tools ["clang-format" "clang-tidy"])
    (on-demand pkgs.haskellPackages.git-annex)
    (on-demand pkgs.gnupg)
    (on-demand pkgs.go)
    (on-demand pkgs.isabelle)
    (on-demand pkgs.ninja)
    (on-demand pkgs.nodejs)
    (on-demand pkgs.pandoc)
    (on-demand pkgs.qemu)
    (on-demand pkgs.rtorrent)
    (on-demand pkgs.sbt)
    (on-demand pkgs.scala)
    (on-demand pkgs.sqlite)
    (on-demand pkgs.swi-prolog)
    (on-demand pkgs.tigervnc)
    (on-demand-bins pkgs.texlive.combined.scheme-full ["latex" "pdflatex"])
    (on-demand-bins pkgs.haskellPackages.warp ["warp"])
    (on-demand pkgs.gdb)
    (on-demand-bins pkgs.gprolog ["gprolog"])
    (on-demand pkgs.wineWow64Packages.full)
    (on-demand pkgs.wasm-pack)
    (on-demand pkgs.cargo-generate)
    (on-demand pkgs.signal-desktop)
    (on-demand pkgs.spirv-tools)
    (on-demand pkgs.zathura)
    (on-demand pkgs.jdk)
    (on-demand (pkgs.lib.hiPrio pkgs.gambit))
    (on-demand pkgs.pstree)
    (on-demand pkgs.emscripten)
    (on-demand pkgs.zathura)
    (on-demand pkgs.shellcheck)
    (on-demand pkgs.typescript)
    (on-demand pkgs.typescript-language-server)
    (on-demand pkgs.qbittorrent)
    (on-demand pkgs.i2p)
    (on-demand pkgs.gh)
    (on-demand pkgs.lorri)
    (on-demand pkgs.swift)
    (on-demand pkgs.mp4v2)
    (on-demand pkgs.asunder)
    (on-demand pkgs.magic-wormhole)
    (on-demand pkgs.oniux)
    (on-demand pkgs.android-studio-tools)
    (on-demand pkgs.android-studio)
    (on-demand pkgs.gemini-cli)
    (on-demand pkgs.webkitgtk_4_1)
    (on-demand pkgs.librsvg)
    (on-demand-bins (pkgs.emacsPackages.withPackages (epkg: [
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
      epkg.cargo
      epkg.cargo-mode
      epkg.rust-auto-use
      epkg.rustic
      epkg.helm-lsp
      epkg.svelte-mode
      epkg.cmake-mode
      epkg.lsp-treemacs
      epkg.vterm
      epkg.eglot
      epkg.prettier
      epkg.treesit-auto
      epkg.treesit-grammars.with-all-grammars
      epkg.hide-mode-line
      epkg.flycheck-projectile
      epkg.helm-company
    ])) ["emacs" "emacsclient"])
  ];

  programs.rclone = {
    enable = true;
  };

  services.blueman-applet.enable = true;

  services.network-manager-applet.enable = true;

  dconf.enable = true;

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 10000;
    };
  };


  # programs.obs-studio = {
  #   enable = true;
  #   plugins = with pkgs.obs-studio-plugins; [
  #     wlrobs
  #     waveform
  #     obs-retro-effects
  #     obs-freeze-filter
  #     obs-vintage-filter
  #   ];
  # };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-m17n
        fcitx5-table-other
        fcitx5-table-extra
        qt6Packages.fcitx5-unikey
      ];
    };
  };
}

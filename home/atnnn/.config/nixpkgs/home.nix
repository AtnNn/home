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
      PATH = "~/.local/bin:$PATH";
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  programs.bash = {
    enable = true;
    # initExtra = "";
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

  programs.waybar.settings = {
    enable = true;
    position = "top";
    layer = "top";
  };
  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4";
      # input =
      # keybindings = let
      #   modifier = config.wayland.windowManager.sway.config.modifier;
      # in lib.mkOptionDefault { }
      # menu =
      # startup = { command = "..."; always = true; }
      # terminal =
      window.hideEdgeBorders = "both";
      # extraSessionCommands = '' ''
      # assigns =
      bars = [{
        command = "$(pkgs.waybar)/bin/waybar";
      }];
    };
    wrapperFeatures.gtk = true;
  };

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
    pkgs.lean
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
    pkgs.firefox
    pkgs.file
  ];
}

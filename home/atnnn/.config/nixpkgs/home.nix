{ ... }:

let
  nixpkgs-path = fetchTarball "https://nixos.org/channels/nixos-20.09/nixexprs.tar.xz";
  home-manager-path = fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";

  pkgs = import nixpkgs-path {};
  home-manager = (import home-manager-path {inherit pkgs;}).home-manager;

  hm-nix-path = "nixpkgs=${nixpkgs-path}:home-manager=${home-manager-path}";

  custom-home-manager = pkgs.writeScriptBin "home-manager" ''
    #!${pkgs.stdenv.shell}
    export NIX_PATH='${hm-nix-path}'
    exec ${home-manager}/bin/home-manager "$@"
  '';
in

{
  home = {
    stateVersion = "20.09";
    username = "atnnn";
    homeDirectory = "/home/atnnn";
    sessionVariables = {
      HM_NIX_PATH = hm-nix-path;
      PATH = "~/.local/bin:$PATH";
    };
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
    package = pkgs.emacs-nox;
    extraPackages = epkg: [
      epkg.flycheck
      epkg.magit
      epkg.helm
      epkg.json-mode
      epkg.nix-mode
      epkg.wgrep
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
      mergetool.emacs.cmd = ''emacs -nw -Q --no-desktop --eval '(ediff-merge-files-with-ancestor \"'$LOCAL'\" \"'$REMOTE'\" \"'$BASE'\" nil \"'$MERGED'\")' '';
      log.abbrevCommit = true;
      log.decorate = "short";
      format.pretty = "oneline";
      color.ui = "auto";
    };
    ignores = [
      "*~"
      "*#"
      "result"
    ];
    userEmail = "etienne@atnnn.com";
    userName = "Etienne Laurin";
  };

  home.file = {
    ".config/nixpkgs/home.nix.current".source = ./home.nix;
    ".config/nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
      }'';
    ".config/nix/nix.conf".text = ''
      experimental-features = nix-command flakes
    '';
  };

  home.packages = [
    pkgs.autoconf
    pkgs.automake
    pkgs.busybox
    (pkgs.lib.hiPrio pkgs.coreutils)
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
    pkgs.sbt
    pkgs.scala
    pkgs.sqlite
    pkgs.swiProlog
    pkgs.tigervnc
    pkgs.texlive.combined.scheme-full
    pkgs.haskellPackages.warp
    pkgs.whois
    pkgs.wine
    pkgs.xterm
    pkgs.gdb
    pkgs.gprolog
    custom-home-manager
  ];
}

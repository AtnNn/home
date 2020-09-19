{ ... }:

let
  nixpkgs-path = fetchTarball "https://nixos.org/channels/nixos-20.09/nixexprs.tar.xz";
  pkgs = import nixpkgs-path {};
in

{
  home = {
    stateVersion = "20.09";
    username = "atnnn";
    homeDirectory = "/home/atnnn";
    sessionVariables = {
      NIX_PATH = "nixpkgs=${nixpkgs-path}";
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

  programs.home-manager = {
    enable = true;
  };

  # home.file = {
  #
  # };

  home.packages = [
    pkgs.autoconf
    pkgs.automake
    pkgs.busybox
    pkgs.cabal-install
    pkgs.cmake
    pkgs.cppcheck
    pkgs.exercism
    (pkgs.lib.hiPrio pkgs.gcc)
    pkgs.clang
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
    (pkgs.lib.hiPrio pkgs.nix)
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
  ];
}

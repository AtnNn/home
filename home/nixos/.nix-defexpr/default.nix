{ pkgs ? import <nixpkgs> {}
}:

{
  inherit (pkgs) vim htop file git;

  emacs = pkgs.emacs;
}

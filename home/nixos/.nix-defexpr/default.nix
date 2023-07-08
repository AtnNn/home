{ pkgs ? import <nixpkgs> {}
}:

{
  inherit (pkgs)
    vim
    htop
    file
    git
    man
    nodejs
    emscripten
    python3
    wget
    nixpkgs-review
    nix-diff;

  emacs = pkgs.emacsWithPackages (epkg: [
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
      epkg.lean-mode
      epkg.cargo
      epkg.cargo-mode
      epkg.rust-auto-use
      epkg.rustic
      epkg.helm-lsp
      epkg.svelte-mode
      epkg.cmake-mode
      epkg.lsp-treemacs
    ]);
}

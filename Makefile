default:

.PHONY: FORCE
FORCE:

nixpkgs.sha256: FORCE
	nix-prefetch-url `eval echo $$(nix-instantiate --eval -A nixpkgs-url)` > $@

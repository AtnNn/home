default:

.PHONY: FORCE
FORCE:

nixpkgs.sha256: FORCE
	nix-prefetch-url --unpack `eval echo $$(nix-instantiate --eval -A nixpkgs-url)` > $@

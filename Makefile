default:

.PHONY: FORCE
FORCE:

nixpkgs.sha256: FORCE
	nix-prefetch-url --unpack `eval echo $$(nix-instantiate --eval -A nixpkgs-url)` > $@

nixpkgs.commit: FORCE
	curl --silent 'https://prometheus.nixos.org/api/v1/query?query=channel_revision' \
	  | jq -r '.data.result.[].metric | select(.channel == "nixos-unstable") | .revision' \
	  > $@

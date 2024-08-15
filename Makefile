.PHONY: default
default:

.PHONY: FORCE
FORCE:

nixpkgs.sha256: FORCE
	nix-prefetch-url --unpack $$(nix-instantiate --eval -A nixpkgs-url --json | jq --raw-output) > $@

nixpkgs.commit: FORCE
	curl --silent 'https://prometheus.nixos.org/api/v1/query?query=channel_revision' \
	  | jq -r '.data.result.[].metric | select(.channel == "nixos-unstable") | .revision' \
	  > $@

nodes/%/nebula.crt: delme/ca.key FORCE
	rm $@
	nebula-cert sign \
	  -ca-crt shared/nebula-ca.crt \
	  -ca-key delme/ca.key \
	  -ip $$(nix-instantiate --eval -A 'nodes.hosts.$*.ip' --json | jq --raw-output)/16 \
	  -name $* \
	  -out-crt $@ \
	  -out-key delme/$*.key

.PHONY: new-ca
new-ca: delme/
	rm shared/nebula-ca.crt
	nebula-cert ca \
	  -name 'AtnNn' \
	  -out-crt shared/nebula-ca.crt \
	  -out-key delme/ca.key

%/:
	mkdir -p $@

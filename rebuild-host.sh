#!/bin/sh

set -eu

nixpkgs=$(eval echo `nix-instantiate . --eval -A nixpkgs`)

host=$1; shift

if [[ "$host" != `hostname` ]]; then
    remote=(
        --build-host $host.mesh.atnnn.com
        --target-host $host.mesh.atnnn.com
        --use-remote-sudo
    )
fi

nixos-rebuild -I nixos-config=nodes/$host/configuration.nix -I nixpkgs=$nixpkgs "${remote[@]}" "$@"

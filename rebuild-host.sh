#!/bin/sh

set -eu

root=$(cd "$(dirname "$0")" && pwd)

nixpkgs=$(eval echo `nix-instantiate . --eval -A nixpkgs`)

host=$1; shift

if [[ "$host" != `hostname` ]]; then
    remote=(
        --build-host $host.mesh.atnnn.com
        --target-host $host.mesh.atnnn.com
        --use-remote-sudo
    )
fi

NIX_PATH="nixos-config=$root/nodes/$host/configuration.nix:nixpkgs=$nixpkgs" \
        nix run ${nixpkgs}#nix -- \
        run ${nixpkgs}#nixos-rebuild -- "${remote[@]}" "$@"

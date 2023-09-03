#!/bin/sh

set -eu

nixpkgs=$(eval echo `nix-instantiate . --eval -A nixpkgs`)

host=$1; shift

nixos-rebuild -I nixos-config=nodes/$host/configuration.nix -I nixpkgs=$nixpkgs "$@"

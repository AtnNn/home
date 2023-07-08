alias gl='git log --graph --color --pretty=format:"%C(auto)%h%d %s %Cblue%an %ar"'

nix-diff-git () (
    set -eux
    path=$1
    base=${2:-`git merge-base HEAD origin/master`}
    a=`nix path-info --derivation ".?ref=$base#$path"`
    b=`nix path-info --derivation ".#$path"`
    nix-diff $a $b
)

export PATH="/home/nixos/.local/bin:$PATH"

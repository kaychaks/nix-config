#! /usr/bin/env nix-shell
#! nix-shell -p nix-prefetch-git -i bash
nix-prefetch-git --rev refs/heads/develop --no-deepClone https://github.com/hlissner/doom-emacs.git > $(dirname $0)/git.json

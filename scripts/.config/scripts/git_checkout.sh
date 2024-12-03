#!/usr/bin/env bash

set -euo pipefail
refs=$(git for-each-ref --format='%(refname:short)' | tr ' ' '\n' | sed -e 's/^origin\///' -e 's/^origin//' | sort -ur)

gitlog="git log --abbrev-commit --decorate --format=format:'%C(auto)%h %C(black)%C(bold)(%cr)%C(reset)%C(auto)%d %C(reset)%C(white)%s %C(dim white)- %an %C(reset)'"
query=$(echo "$refs" | fzf --print-query --preview "$gitlog --color=always {} 2> /dev/null || $gitlog --color=always origin/{}" || true)

q=$(echo "$query" | head -1)
branch=$(echo "$query" | tail -1)

if [ -z "$q" ] && [ -z "$branch" ]; then
    exit 0
fi

if echo "$refs" | grep -q "^$branch$"; then
    git checkout $branch
    exit 0
fi

echo "Branch not found. Creating new branch \"$q\""
git checkout -b "$q"

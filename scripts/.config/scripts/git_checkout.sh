#!/usr/bin/env bash

set -euo pipefail

# Check if worktree setup: bare repo, multiple worktrees, or .git is a file
is_worktree() {
    git rev-parse --is-bare-repository 2>/dev/null | grep -q true && return 0
    [ "$(git worktree list | wc -l)" -gt 1 ] && return 0
    [ -f "$(git rev-parse --show-toplevel 2>/dev/null)/.git" ] && return 0
    return 1
}

# Worktree root: parent of first worktree in list (the main one)
worktree_root() { dirname "$(git worktree list --porcelain | head -1 | cut -d' ' -f2)"; }

refs=$(git for-each-ref --format='%(refname:short)' | tr ' ' '\n' | sed -e 's/^origin\///' -e 's/^origin//' | sort -ur)
gitlog="git log --abbrev-commit --decorate --format=format:'%C(auto)%h %C(black)%C(bold)(%cr)%C(reset)%C(auto)%d %C(reset)%C(white)%s %C(dim white)- %an %C(reset)'"
query=$(echo "$refs" | fzf --print-query --preview "$gitlog --color=always {} 2> /dev/null || $gitlog --color=always origin/{}" || true)

q=$(echo "$query" | head -1)
branch=$(echo "$query" | tail -1)

[ -z "$q" ] && [ -z "$branch" ] && exit 0

# existing branch selected
if echo "$refs" | grep -q "^$branch$"; then
    if is_worktree; then
        new_path="$(worktree_root)/$branch"

        git worktree add "$new_path" "$branch" >&2
        echo "$new_path"
        exit 42
    elif [ -d .git ]; then
        git checkout "$branch"
    fi
    exit 0
fi

# new branch
if is_worktree; then
    new_path="$(worktree_root)/$q"
    git worktree add "$new_path" -b "$q" >&2
    echo "$new_path"
    exit 42
else
    git checkout -b "$q"
fi

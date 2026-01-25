#!/usr/bin/env bash

set -euo pipefail

# Check if worktree setup: bare repo, multiple worktrees, or .git is a file
is_worktree() {
    git rev-parse --is-bare-repository 2>/dev/null | grep -q true && return 0
    [ "$(git worktree list | wc -l)" -gt 1 ] && return 0
    [ -f "$(git rev-parse --show-toplevel 2>/dev/null)/.git" ] && return 0
    return 1
}

worktree_root() { git rev-parse --git-common-dir 2>/dev/null; }

refs=$(git for-each-ref --format='%(refname:short)' | tr ' ' '\n' | sed -e 's/^origin\///' -e 's/^origin//' | sort -ur)
gitlog="git log --abbrev-commit --decorate --format=format:'%C(auto)%h %C(black)%C(bold)(%cr)%C(reset)%C(auto)%d %C(reset)%C(white)%s %C(dim white)- %an %C(reset)'"
query=$(echo "$refs" | fzf --print-query --preview "$gitlog --color=always {} 2> /dev/null || $gitlog --color=always origin/{}" || true)

q=$(echo "$query" | head -1)
branch=$(echo "$query" | tail -1)

[ -z "$q" ] && [ -z "$branch" ] && exit 0

branch_exists=false
if echo "$refs" | grep -q "^$branch$"; then
    branch_exists=true
fi

if is_worktree; then
    target="$q"
    if [ "$branch_exists" = true ]; then
        target="$branch"
    fi

    existing_path=""
    if [ -n "$branch" ]; then
        existing_path="$(git worktree list --porcelain | awk -v branch="refs/heads/$branch" '
            $1 == "worktree" { path = $2 }
            $1 == "branch" && $2 == branch { print path; exit }
        ')"
    fi

    if [ -n "$existing_path" ] && [ -d "$existing_path" ]; then
        echo "$existing_path"
        exit 0
    fi

    new_path="$(worktree_root)/$target"
    if ! git worktree add "$new_path" "$target" >/dev/null 2>&1; then
        git worktree add "$new_path" -b "$target" >/dev/null
    fi
    echo "$new_path"
    exit 0
fi

if [ "$branch_exists" = true ]; then
    git checkout "$branch"
    exit 0
fi

git checkout -b "$q"

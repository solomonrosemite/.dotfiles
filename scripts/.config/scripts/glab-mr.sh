#!/usr/bin/env bash

USERNAME="${USERNAME:-"solomon"}"

set -euo pipefail
TMP_FILE=$(mktemp "${TMPDIR:-/tmp}/-COMMIT_EDITMSG")

cleanup() {
    rm -f "$TMP_FILE"
}
trap cleanup EXIT

gs=$(git status | grep -vE '\(use "git (restore|add)' | sed -e 's/^\t/#\t/' -e 's/^$/\#/' -e '/^#/!s/^/# /')

printf '\n%s' \
    "# Please enter the commit message for your changes. Lines starting" \
    "# with '#' will be ignored, and an empty message aborts the merge." \
    "#" \
    "$gs" > "$TMP_FILE"

nvim -c "set filetype=gitcommit" -c "set nowritebackup" "$TMP_FILE"
# nvim -c "set filetype=gitcommit" -c "startinsert" -c "set nowritebackup" "$TMP_FILE"

MR_TITLE=$(head -n 1 < "$TMP_FILE")
MR_DESCRIPTION=$(sed -e '1d' -e '/^#/,$d' "$TMP_FILE" | sed '/^$/d')

if [[ -z "$MR_TITLE" ]]; then
    echo "Merge request creation canceled."
    exit 1
fi

echo "Creating merge request..."
glab mr create \
    --remove-source-branch \
    --yes \
    --squash-before-merge \
    -a "$USERNAME" \
    --no-editor \
    -d "$MR_DESCRIPTION" \
    -t "$MR_TITLE"


#!/usr/bin/env bash

parser_definition() {
  setup   REST help:usage -- "Usage: [options] [directories...]" ''
  msg -- 'Interactive directory selector using fzf' ''
  msg -- 'Options:'
  param   max_depth -d --depth init:=1 -- "Set maximum search depth (default: 1)"
  param   fzf_nth   -n --nth init:=-1 -- "Set fzf field number for display (default: -1, show last field)"
  disp    :usage    -h --help           -- "Display this help message and exit."
}
eval "$(getoptions parser_definition) exit 1"

# Function to recursively find directories, stopping at git repositories
find_dirs_stop_at_git() {
    local search_dirs=("$@")
    local current_depth=1
    local found_dirs=()

    # Filter out non-existent directories from initial search
    local valid_dirs=()
    for dir in "${search_dirs[@]}"; do
        if [[ -d "$dir" && -r "$dir" ]]; then
            valid_dirs+=("$dir")
        fi
    done

    # If no valid directories, return empty
    [[ ${#valid_dirs[@]} -eq 0 ]] && return

    # Process directories level by level
    local dirs_to_process=("${valid_dirs[@]}")

    while [[ $current_depth -le $max_depth && ${#dirs_to_process[@]} -gt 0 ]]; do
        local next_level_dirs=()

        for dir in "${dirs_to_process[@]}"; do
            # Skip if directory doesn't exist or is not readable (shouldn't happen now, but safety check)
            [[ ! -d "$dir" || ! -r "$dir" ]] && continue

            # Find all subdirectories at current level (excluding hidden ones)
            while IFS= read -r -d '' subdir; do
                # Add to found directories list
                found_dirs+=("$subdir")

                # Check if this directory contains a .git folder
                if [[ -d "$subdir/.git" ]]; then
                    # This is a git repository, don't recurse deeper
                    continue
                fi

                # Add to next level for further processing if we haven't reached max depth
                if [[ $current_depth -lt $max_depth ]]; then
                    next_level_dirs+=("$subdir")
                fi
            done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d -not -path '*/.*' -print0 2>/dev/null)
        done

        dirs_to_process=("${next_level_dirs[@]}")
        ((current_depth++))
    done

    # Output all found directories
    printf '%s\n' "${found_dirs[@]}"
}

# Search for directories using fzf
# Note: Don't use directories="$@" as it creates a single string, use the array directly
if [[ "$fzf_nth" == "0" ]]; then
    selected_dir=$(find_dirs_stop_at_git "$@" | sort | fzf --delimiter="/")
else
    selected_dir=$(find_dirs_stop_at_git "$@" | sort | fzf --delimiter="/" --nth="$fzf_nth")
fi

# Check if a directory was selected
if [[ -z "$selected_dir" ]]; then
    pwd
    exit 1
fi

echo "$selected_dir"

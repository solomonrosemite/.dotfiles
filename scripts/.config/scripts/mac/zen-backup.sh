#!/usr/bin/env bash

set -euo pipefail

ZEN_SOURCE="${ZEN_SOURCE:-/Users/solomon/Library/Application Support/zen/Profiles/a2iwemll.Default (release)/sessionstore-backups}"
ZEN_DEST="${ZEN_DEST:-/Users/solomon/Library/Application Support/zen/zen-session-backups}"

if [ ! -d "$ZEN_SOURCE" ]; then
    echo "Error: Source directory does not exist: $ZEN_SOURCE" >&2
    exit 1
fi

mkdir -p "$ZEN_DEST"

backup_name="zen-$(date +%Y-%m-%d)"
backup_path="$ZEN_DEST/$backup_name"

today_backup=$(ls -d "$ZEN_DEST"/zen-$(date +%Y-%m-%d)* 2>/dev/null || true)
if [ -n "$today_backup" ]; then
    echo "Backup for today already exists: $today_backup"
    exit 0
fi

cp -r "$ZEN_SOURCE" "$backup_path"

echo "Backup created: $backup_path"

#!/bin/bash
input=$(cat)
dir=$(jq -r '.workspace.current_dir // .cwd' <<<"$input")
pct=$(jq -r '.context_window.used_percentage // empty' <<<"$input")
branch=$(git -C "$dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)
printf '\033[35m%s\033[0m' "${dir/#$HOME/~}"
[ -n "$branch" ] && printf ' \033[36m%s\033[0m' "$branch"
[ -n "$pct" ] && printf ' %s%% ctx' "${pct%.*}"
printf ' 🐈'

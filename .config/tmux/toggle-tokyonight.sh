#!/usr/bin/env bash
# Toggle tmux chrome between Tokyo Night night and day (see tokyonight-*.conf).
set -eu
TMUX_CONFIG="${TMUX_CONFIG:-$HOME/.config/tmux}"
current="$(tmux show -gv @tokyonight-variant 2>/dev/null || true)"
if [ "$current" = "day" ]; then
	tmux set -g @tokyonight-variant night
	tmux source-file "$TMUX_CONFIG/tokyonight-night.conf"
else
	tmux set -g @tokyonight-variant day
	tmux source-file "$TMUX_CONFIG/tokyonight-day.conf"
fi

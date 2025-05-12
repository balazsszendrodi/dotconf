#!/usr/bin/env bash
# Capture the entire visible pane history
content=$(tmux capture-pane -pS - -J | sed -e 's/^[^➜❮]* [➜❮] //' -e '/^$/d')
# Run fzf in reverse mode (most recent lines on top) with a custom prompt
query=$(echo "$content" | fzf --reverse --prompt="Search: ")
# If a line was selected, initiate a search in tmux copy mode
if [ -n "$query" ]; then
  tmux send-keys "$query"
fi

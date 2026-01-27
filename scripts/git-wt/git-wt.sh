# Git Worktree Workflow Shell Functions
# Source this file in your .bashrc or .zshrc:
#   source /path/to/git-wt.sh

# Directory where the scripts are located
GIT_WT_SCRIPT_DIR="${GIT_WT_SCRIPT_DIR:-$(dirname "${BASH_SOURCE[0]:-$0}")}"

# Wrapper for git-wt-clone - clones and cd's into the directory
git-wt-clone() {
  local exit_code
  local target_dir=""

  # Parse arguments to find the target directory
  local repo_url=""
  local dir_arg=""
  local args=()

  while [[ $# -gt 0 ]]; do
    case $1 in
    --exclude-branch)
      args+=("$1" "$2")
      shift 2
      ;;
    --help | -h)
      "$GIT_WT_SCRIPT_DIR/git-wt-clone" --help
      return
      ;;
    *)
      if [[ -z "$repo_url" ]]; then
        repo_url="$1"
        args+=("$1")
      elif [[ -z "$dir_arg" ]]; then
        dir_arg="$1"
        args+=("$1")
      fi
      shift
      ;;
    esac
  done

  # Determine target directory
  if [[ -n "$dir_arg" ]]; then
    target_dir="$dir_arg"
  elif [[ -n "$repo_url" ]]; then
    target_dir=$(basename "$repo_url" .git)
  fi

  # Run the actual clone script
  "$GIT_WT_SCRIPT_DIR/git-wt-clone" "${args[@]}"
  exit_code=$?

  # If successful and we have a target, cd into it
  if [[ $exit_code -eq 0 ]] && [[ -n "$target_dir" ]] && [[ -d "$target_dir" ]]; then
    echo "==> Changing to $target_dir"
    cd "$target_dir" || exit_code=1
  fi

  return $exit_code
}

# Wrapper for git-wt-add - creates worktree and cd's into it
git-wt-add() {
  local branch=""
  local args=("$@")

  # Parse arguments to find the branch name
  for arg in "$@"; do
    case $arg in
    --force-fetch | --new | --help | -h) ;;
    *)
      if [[ -z "$branch" ]]; then
        branch="$arg"
      fi
      ;;
    esac
  done

  # Run the actual add script
  "$GIT_WT_SCRIPT_DIR/git-wt-add" "${args[@]}"
  local exit_code=$?

  # If successful, cd into the worktree
  if [[ $exit_code -eq 0 ]] && [[ -n "$branch" ]]; then
    # Find repo root
    local repo_root="$PWD"
    while [[ "$repo_root" != "/" ]]; do
      if [[ -f "$repo_root/.git" ]] || [[ -d "$repo_root/.bare" ]]; then
        break
      fi
      repo_root=$(dirname "$repo_root")
    done

    # Sanitize branch name for directory
    local worktree_name=$(echo "$branch" | tr '/' '.')
    local worktree_path="$repo_root/$worktree_name"

    if [[ -d "$worktree_path" ]]; then
      echo "==> Changing to $worktree_path"
      cd "$worktree_path" || exit_code=1
    fi
  fi

  return $exit_code
}

# Direct passthrough for other commands (no directory change needed)
git-wt-remove() {
  "$GIT_WT_SCRIPT_DIR/git-wt-remove" "$@"
}

git-wt-list() {
  "$GIT_WT_SCRIPT_DIR/git-wt-list" "$@"
}

git-wt-fetch() {
  "$GIT_WT_SCRIPT_DIR/git-wt-fetch" "$@"
}

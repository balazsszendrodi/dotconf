# Git Worktree Workflow Scripts

A set of scripts to manage git repositories using a bare repository + worktree workflow. This approach keeps your repository organized with each branch in its own directory.

## Features

- **Bare repository storage**: The actual git data is stored in a `.bare` directory
- **Branch isolation**: Each branch gets its own worktree directory
- **Partial clone**: Uses `--filter=blob:none` to avoid downloading all blobs upfront
- **Branch exclusion**: Exclude large/binary branches from default fetches
- **On-demand fetching**: Blobs are fetched only when needed

## Installation

**Recommended: Source the shell functions** (enables auto-cd after clone/add):

```bash
# Add to your ~/.bashrc or ~/.zshrc:
source /path/to/git-wt.sh

# Or with a custom script location:
export GIT_WT_SCRIPT_DIR="/path/to/scripts"
source /path/to/git-wt.sh
```

**Alternative: Just add scripts to PATH** (no auto-cd):

```bash
chmod +x git-wt-*
export PATH="$PATH:/path/to/these/scripts"
# Or copy to a bin directory
cp git-wt-* ~/.local/bin/
```

## Usage

### Clone a Repository

```bash
# Basic clone
git-wt-clone https://github.com/user/repo.git

# Clone with custom directory name
git-wt-clone https://github.com/user/repo.git my-project

# Clone and exclude a branch with binaries
git-wt-clone https://github.com/user/repo.git my-project --exclude-branch binaries
```

This creates a structure like:
```
my-project/
├── .bare/          # Bare git repository
└── .git            # File pointing to .bare
```

### Create a Worktree for a Branch

```bash
# Checkout an existing remote branch
git-wt-add main
git-wt-add feature/awesome

# Create a new local branch
git-wt-add my-new-feature --new

# Force fetch an excluded branch (e.g., one with binaries)
git-wt-add binaries --force-fetch
```

After adding worktrees:
```
my-project/
├── .bare/
├── .git
├── main/           # Worktree for main branch
└── feature-awesome/ # Worktree for feature/awesome branch
```

### List Worktrees and Branches

```bash
# List active worktrees and available branches
git-wt-list

# Include excluded branches in the list
git-wt-list --all
```

### Fetch Updates

```bash
# Normal fetch (respects exclusions)
git-wt-fetch

# Fetch all branches including excluded ones
git-wt-fetch --all

# Fetch a specific branch
git-wt-fetch --branch binaries
```

### Remove a Worktree

```bash
# Remove a worktree
git-wt-remove feature/awesome

# Force remove (even with uncommitted changes)
git-wt-remove feature/awesome --force
```

## Workflow Example

```bash
# 1. Clone the repository, excluding the 'assets' branch with binaries
git-wt-clone https://github.com/myorg/myrepo.git myrepo --exclude-branch assets

# 2. Create a worktree for the main branch
cd myrepo
git-wt-add main
cd main

# 3. Start a new feature
git-wt-add feature/new-feature --new
cd ../feature-new-feature

# 4. Work on your feature...
# Make changes, commit, push, etc.

# 5. When done, remove the feature worktree
cd ..
git-wt-remove feature/new-feature

# 6. If you need the binary assets branch
git-wt-add assets --force-fetch
```

## How It Works

### Bare Repository Setup

The scripts clone repositories as bare repos with partial clone enabled:
```bash
git clone --bare --filter=blob:none <url> .bare
```

This means:
- No working directory in the bare repo
- Blobs (file contents) are fetched on-demand
- Only the commit/tree structure is downloaded initially

### Remote Tracking

Bare repositories don't track remote branches by default. The scripts configure:
```bash
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
```

### Branch Exclusion

To exclude a branch (like one containing binaries), a negative refspec is used:
```bash
git config --add remote.origin.fetch "^refs/heads/<branch>"
```

This prevents the branch from being fetched during normal `git fetch` operations.

## Tips

1. **Navigate quickly**: Use shell aliases to jump between worktrees
   ```bash
   alias cdmain='cd ~/projects/myrepo/main'
   ```

2. **Shared node_modules**: For JS projects, consider using symlinks or pnpm workspaces

3. **IDE setup**: Open the specific worktree directory in your IDE, not the root

4. **Git operations**: Regular git commands work inside each worktree

## Requirements

- Git 2.29+ (for negative refspecs)
- Git 2.25+ (for `--filter` partial clone support)
- Bash 4+

## Troubleshooting

### "Remote branch not found"
Run `git-wt-fetch` to update the list of remote branches, or check if the branch is excluded.

### "Cannot remove worktree while inside it"
Change to a different directory before removing a worktree.

### Excluded branch not appearing
Use `git-wt-list --all` to see excluded branches, or `git-wt-fetch --branch <name>` to fetch it.

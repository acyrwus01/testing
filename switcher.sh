#!/bin/bash

# Check if inside a Git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Not in a Git repository."
    exit 1
fi

# List all branches (local and remote) and use gum to select one
selected_branch=$(git branch --all --format '%(refname:lstrip=2)' | gum choose)

# Check if a branch was selected
if [ -z "$selected_branch" ]; then
    echo "No branch selected."
    exit 0
fi

remote_branch=${selected_branch#*/}
git checkout "$remote_branch"

